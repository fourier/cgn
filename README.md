Code generator (cgn)
====================
This project makes it simple to generate Java source code (variations of [POJO](http://en.wikipedia.org/wiki/Plain_Old_Java_Object)) and Json parser/gerenartor for them (based on [jackson](https://github.com/FasterXML/jackson)) using [Saxon HE](http://saxon.sourceforge.net/) XSL processor.

The Saxon XSLT and XQuery processor developed by [Saxonica](http://www.saxonica.com/). One can install the [Saxon Home Edition](http://sourceforge.net/projects/saxon/files/Saxon-HE/) in order to use cgn. Please specify the path to Saxon (SAXON_PATH) in supplied *.sh files in the [examples](https://github.com/fourier/cgn/tree/master/examples) directory.

The aim of the project is to automate as much as possible with generated objects. The JAVA language is the one of possible backends; in future other languages support could be added (beginning with the plain C and ObjectiveC, allowing users for example do define data model in XML form and generate the code for both Android and iOS).

Features
========
The **cgn** allows to generate:
* Java POJOs and alike
* JSON parser for the generated POJOs 
* JSON generator for generated POJOs

The user can set the following properties for the generated objects:
* names
* packages
* copyright statements
* authorship statements
* if the setters should be generated along with getters(read-only)
* if the methods accompanying fields should be generated (isSetSomething family of methods)
* if the object should be used by JSON parser/generator
* the type of fields: string, date, int, double, long, boolean, byte or user-defined from one of the generated objects only

Java specific properties which could be set:
* if generate the [Builder](http://www.javaworld.com/article/2074938/core-java/too-many-parameters-in-java-methods-part-3-builder-pattern.html) for the class
* if generate the (Parcelable)(http://developer.android.com/reference/android/os/Parcelable.html) support for the class
* Joda DateTime type for date(*java.util.Date* is the default): if the *jcgn:type* attribute is set to *org.joda.time.DateTime* on a *cgn:date* field, this type will be used instead of *java.util.Date*. Other types not supported for now.
* Inject user's code into the generated class

Directory structure
===================
<pre>
.
├── examples - usage example
├── json - JSON parser generator
│   └── java
├── objects - Plain Objects (currently only POJO generated) 
│   └── java
└── saxon - SAXON is XSL processor (http://saxon.sourceforge.net)
</pre>

Usage
========
The user should specify the objects he is willing to generate using XML description. The **cgn** designed to be extensible with generation for other languages, not only java, therefore its elements defined in 2 namespaces for now: *xmlns:cgn="https://github.com/fourier/cgn"* and *xmlns:jcgn="https://github.com/fourier/cgn/java"*. The object fields specific for all output languages (currently Java only) should be declared in **cgn** namespace, the Java-specific should be declared in **jcgn** namespace.

Gradle task
===========
One can easily integrate the code generation routine into the gradle-based project, considering Saxon is available at the Maven central repository.
First, don't forget to include Maven Central as a repository into your **build.gradle**:

```groovy
repositories {
    jcenter()
    mavenCentral()
}
```

Add the **gen/** dir to the java.srcDirs, assuming **src/** is the sources directory:

```groovy
sourceSets {
        main {
            java.srcDirs = ['src/', 'gen/']
```

We need to add a new configuration **saxon** in order to find the path to the Saxon jar file:

```groovy
configurations {
    saxon
}
````

Now add compile-time dependencies:

```groovy
dependencies {
    saxon 'net.sf.saxon:Saxon-HE:9.6.0-3'
    compile fileTree('gen') {
        builtBy 'gensrcs'
    }
    compile files(['../protocol/protocol.xml'])
}
```

Here the **gensrcs** is the task used to generate sources, and **../protocol/protocol.xml** is the xml file with the objects description

Now we need to add the final steps:

```groovy
// path to generated sources, relative to the root
def generatedDir = new File('gen/')

task cleansrcs << {
    description 'remove generated sources'
    println 'Removing old generated sources ...'
    if (generatedDir.isDirectory()) {
        generatedDir.deleteDir()
    }
}

// determine path to Saxon jar file downloaded from Maven central
def findSaxonJar() {
    return configurations.saxon.asPath
}

// Code generation task
task gensrcs(type: JavaExec) {
    description 'Regenerate code using cgn package'
    doFirst {
        println 'Generating new sources for the data model...'
    }
    inputs.file '../protocol/protocol.xml'
    outputs.dir 'gen'
    workingDir '../protocol/'
    classpath findSaxonJar()
    main 'net.sf.saxon.Transform'
    args = ['-s:protocol.xml', '-xsl:path/to/cgn/objects/java/java_genobjects.xsl', '-it:"{https://github.com/fourier/cgn/java}genobjects"', '-o:../path/to/gen/directory/.dummy.xml']
}

// generate sources with gen before performing the build
// sources generated only if "gen" dir is not existing
preBuild.dependsOn gensrcs

// remove generated sources before doing the clean
clean.dependsOn cleansrcs
```


Examples
========
First, explore the [example.xml](https://github.com/fourier/cgn/blob/master/examples/example.xml) in ***examples*** directory for the example and descriptions of all possible fields.
To use the ***example.xml*** to generate sources, go to the ***examples*** directory and run
<pre>
./genpojos_and_parser.sh
</pre>

It will generate the ***gen*** directory with sources (POJOs and JSON parser) based on schemas in the ***example.xml*** file.


Example how to specify simple objects:
```xml
  <objects cgn:package="com.mycompany.users"
           cgn:copyright="Copyright (c) 2014 by My Company&#10;This file and its contents are Confidential."
           cgn:author="The Author">
    <object cgn:name="PersonalUserData" cgn:read-only="false" cgn:json="true" jcgn:parcelable="true">
      <field cgn:name="name"/>
      <field cgn:name="occupation"/>
      <field cgn:name="age" cgn:type="int"/>
      <field cgn:name="visits" cgn:type="[date]"/>
    </object>

    <object cgn:name="Employee" cgn:read-only="true" jcgn:builder="true" jcgn:parcelable="true">
      <field cgn:name="id" cgn:type="int"/>
      <field cgn:name="data" cgn:type="PersonalUserData"/>
      <field cgn:name="probation" cgn:type="boolean" />
      <field cgn:name="started" cgn:type="date" jcgn:type="org.joda.time.DateTime"/>
      <jcgn:source>
    public void dumpEmployee() {
        System.out.println("Employee " + mData.getName() + " started at " + org.joda.time.format.DateTimeFormat.shortDate().print(mStarted));        
    }        
      </jcgn:source>
    </object>
  </objects>
```

Here we create a package and 2 objects in a package. We also include the copyright statement into the output files.

The first object, ***PersonalUserData***, will have setters and will have a JSON-parser/generator created. It will also implements the [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html) interface. If the field doesn't have a type, the **string** type assumed. One can see how to define arrays as types as well - using square brackets as in **visits** field. 

The second object, ***Employee** will not have any setters, however the [Builder](http://en.wikipedia.org/wiki/Builder_pattern) inner class will be generated. The object as well will implement Android's [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html) interface. One can see how the previously defined object can be used as a field type. The *started* field will have a *org.joda.time.DateTime* type. It will also include user-specified function *dumpEmployee*.

The generated code is:

```java
/**
 * Copyright (c) 2014 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.users;



/**
 * Generated by The Author from example.xml on 12/1/2015
 */
public class PersonalUserData implements android.os.Parcelable {
    /**
     * private fields 
     */
    private String mName;
    private String mOccupation;
    private int mAge;
    private java.util.ArrayList<java.util.Date> mVisits;

    public PersonalUserData() {
    }

    public PersonalUserData(String name, String occupation, int age, java.util.ArrayList<java.util.Date> visits) {
        mName = name;
        mOccupation = occupation;
        mAge = age;
        mVisits = visits;
    }

    /**
     * Implementing Parcelable interface 
     */

    /**
     * Parses the string specified using supplied formatter
     *
     * @param dateString   string to parse
     * @param format       formatter used to parse the date string
     * @return             parsed Date object or Date epoch object in case of error
     */
    private static java.util.Date parseDate(String dateString, java.text.SimpleDateFormat format) {
        java.util.Date result = new java.util.Date(0);
        try {
            result = format.parse(dateString);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    public PersonalUserData(android.os.Parcel in) {
        final java.text.SimpleDateFormat ISO8601_JAVA_DATE_FORMAT = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        this.mName = in.readString();
        this.mOccupation = in.readString();
        this.mAge = in.readInt();
        this.mVisits = new java.util.ArrayList<java.util.Date>();
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            in.readStringList(tmpArray);
            for (String date : tmpArray)
                this.mVisits.add(parseDate(date, ISO8601_JAVA_DATE_FORMAT));
        };
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        final java.text.SimpleDateFormat ISO8601_JAVA_DATE_FORMAT = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        out.writeString(mName);
        out.writeString(mOccupation);
        out.writeInt(mAge);
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            for (java.util.Date date : mVisits)
                tmpArray.add(ISO8601_JAVA_DATE_FORMAT.format(date));
            out.writeStringList(tmpArray);
        };
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<PersonalUserData> CREATOR = new android.os.Parcelable.Creator<PersonalUserData>() {
        public PersonalUserData createFromParcel(android.os.Parcel in) {
            return new PersonalUserData(in);
        }
        public PersonalUserData[] newArray(int size) {
            return new PersonalUserData[size];
        }
    };

    /**
     * Parcelable interface implementation done 
     */

    /**
     * Getters 
     */

    /**
     * @return the value of the "name" field
     */
    public String getName() {
        return this.mName;
    }

    /**
     * @return the value of the "occupation" field
     */
    public String getOccupation() {
        return this.mOccupation;
    }

    /**
     * @return the value of the "age" field
     */
    public int getAge() {
        return this.mAge;
    }

    /**
     * @return the value of the "visits" field
     */
    public java.util.ArrayList<java.util.Date> getVisits() {
        return this.mVisits;
    }

    /**
     * Setters 
     */

    /**
     * Sets the "name" field to the value supplied 
     * 
     * @param name the value to the set into the "name" field
     * @return reference to this object instance
     */
    public PersonalUserData setName(String name) {
        this.mName = name;
        return this;
    }

    /**
     * Sets the "occupation" field to the value supplied 
     * 
     * @param occupation the value to the set into the "occupation" field
     * @return reference to this object instance
     */
    public PersonalUserData setOccupation(String occupation) {
        this.mOccupation = occupation;
        return this;
    }

    /**
     * Sets the "age" field to the value supplied 
     * 
     * @param age the value to the set into the "age" field
     * @return reference to this object instance
     */
    public PersonalUserData setAge(int age) {
        this.mAge = age;
        return this;
    }

    /**
     * Sets the "visits" field to the value supplied 
     * 
     * @param visits the value to the set into the "visits" field
     * @return reference to this object instance
     */
    public PersonalUserData setVisits(java.util.ArrayList<java.util.Date> visits) {
        this.mVisits = visits;
        return this;
    }

}
```

and

```java
/**
 * Copyright (c) 2014 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.users;



/**
 * Generated by The Author from example.xml on 12/1/2015
 */
public class Employee implements android.os.Parcelable {
    /**
     * private fields 
     */
    private final int mId;
    private final PersonalUserData mData;
    private final boolean mProbation;
    private final org.joda.time.DateTime mStarted;

    /**
     * Internal Builder class for the Employee
     */
    public static class Builder {

        private int mId;
        private PersonalUserData mData;
        private boolean mProbation;
        private org.joda.time.DateTime mStarted;

        public Builder() {
        }

        /**
         * Sets the "id" field to the value supplied 
         * 
         * @param id the value to the set into the "id" field
         * @return reference to this object instance
         */
        public Builder setId(int id) {
            this.mId = id;
            return this;
        }

        /**
         * Sets the "data" field to the value supplied 
         * 
         * @param data the value to the set into the "data" field
         * @return reference to this object instance
         */
        public Builder setData(PersonalUserData data) {
            this.mData = data;
            return this;
        }

        /**
         * Sets the "probation" field to the value supplied 
         * 
         * @param probation the value to the set into the "probation" field
         * @return reference to this object instance
         */
        public Builder setProbation(boolean probation) {
            this.mProbation = probation;
            return this;
        }

        /**
         * Sets the "started" field to the value supplied 
         * 
         * @param started the value to the set into the "started" field
         * @return reference to this object instance
         */
        public Builder setStarted(org.joda.time.DateTime started) {
            this.mStarted = started;
            return this;
        }

        /**
         * Creates the object instance 
         * @return created instance of the <code>Employee</code>
         */
        public Employee create() {
            return new Employee(this);
        }
    }

    public Employee(int id, PersonalUserData data, boolean probation, org.joda.time.DateTime started) {
        mId = id;
        mData = data;
        mProbation = probation;
        mStarted = started;
    }

    /**
     * Constructor from the Builder 
     */
    protected Employee(Builder builder) {
        mId = builder.mId;
        mData = builder.mData;
        mProbation = builder.mProbation;
        mStarted = builder.mStarted;
    }

    /**
     * Implementing Parcelable interface 
     */

    /**
     * Parses the string specified using supplied formatter
     *
     * @param dateString   string to parse
     * @param format       formatter used to parse the date string
     * @return             parsed DateTime object or DateTime epoch object in case of error
     */
    private static org.joda.time.DateTime parseDate(String dateString, org.joda.time.format.DateTimeFormatter format) {
        org.joda.time.DateTime result = new org.joda.time.DateTime(0);
        try {
            result = format.parseDateTime(dateString);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    public Employee(android.os.Parcel in) {
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        this.mId = in.readInt();
        this.mData = (PersonalUserData)in.readParcelable(PersonalUserData.class.getClassLoader());
        this.mProbation = in.readByte() != 0;
        this.mStarted = parseDate(in.readString(), ISO8601_JODA_DATE_FORMAT);
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        out.writeInt(mId);
        out.writeParcelable(mData, flags);
        out.writeByte((byte)(mProbation ? 1 : 0));
        out.writeString(ISO8601_JODA_DATE_FORMAT.print(mStarted));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<Employee> CREATOR = new android.os.Parcelable.Creator<Employee>() {
        public Employee createFromParcel(android.os.Parcel in) {
            return new Employee(in);
        }
        public Employee[] newArray(int size) {
            return new Employee[size];
        }
    };

    /**
     * Parcelable interface implementation done 
     */

    /**
     * Getters 
     */

    /**
     * @return the value of the "id" field
     */
    public int getId() {
        return this.mId;
    }

    /**
     * @return the value of the "data" field
     */
    public PersonalUserData getData() {
        return this.mData;
    }

    /**
     * @return the value of the "probation" field
     */
    public boolean getProbation() {
        return this.mProbation;
    }

    /**
     * @return the value of the "started" field
     */
    public org.joda.time.DateTime getStarted() {
        return this.mStarted;
    }


    public void dumpEmployee() {
        System.out.println("Employee " + mData.getName() + " started at " + org.joda.time.format.DateTimeFormat.shortDate().print(mStarted));        
    }        
      
}
```
