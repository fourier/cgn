Code generator (cgn)
====================
This project makes it simple to generate POJOs and Json parser (based on [jackson](https://github.com/FasterXML/jackson)) using [Saxon HE](http://saxon.sourceforge.net/) XSL processor.

Directory structure:
<pre>
.
├── examples - usage example
├── json - JSON parser generator
│   └── java
├── objects - Plain Objects (currently only POJO generated) 
│   └── java
└── saxon - SAXON is XSL processor (http://saxon.sourceforge.net)
</pre>

Example how to specify simple object:
```xml
<objects cgn:package="com.veroveli.example">

    <object cgn:name="PersonalUserData" cgn:read-only="false" cgn:json="true">
      <field cgn:name="name"/>
      <field cgn:name="occupation"/>
      <field cgn:name="age" cgn:type="int"/>
      <field cgn:name="completed-at" cgn:type="date"/>
      <field cgn:name="visits" cgn:type="[date]"/>
    </object>

    <object cgn:name="Employee" cgn:read-only="true" jcgn:builder="true" jcgn:parcelable="true">
      <field cgn:name="id" cgn:type="int"/>
      <field cgn:name="personalUserData" cgn:type="PersonalUserData"/>
      <field cgn:name="vacation" cgn:type="boolean"/>
    </object>
</objects>
```

Here we create a package and 2 objects in a package. 

The first object, ***PersonalUserData***, will have setters and will have a JSON-parser/generator created. If the field doesn't have a type, the **string** type assumed. One can see how to define arrays as types as well - using square brackets as in **visits** field. 

The second object will not have any setters, however the [Builder](http://en.wikipedia.org/wiki/Builder_pattern) inner class will be generated. The object as well will implement Android's [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html) interface. One can see how the previously defined object can be used as a field type.


See the the [example.xml](https://github.com/fourier/cgn/blob/master/examples/example.xml) in ***examples*** directory for the example and descriptions of all possible fields.
To use the ***example.xml*** to generate sources, go to the ***examples*** directory and run
<pre>
./genpojos_and_parser.sh
</pre>

It will generate the ***gen*** directory with sources (POJOs and JSON parser) based on schemas in the ***example.xml*** file.

One more example. Let's create a package ***com.mycompany.example*** with 2 classes in it: **WorkPackage** and **Model**. Both will have getters and setters, and have builders (for lazy), and will implement  [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html) interface:

```xml
  <objects cgn:package="com.mycompany.example"
           cgn:read-only="false"
           jcgn:builder="true"
           jcgn:parcelable="true">
    <cgn:object cgn:name="WorkPackage">
      <cgn:field cgn:name="customer-id" cgn:type="long" />
      <cgn:field cgn:name="workcode-id" cgn:type="long"/>
      <cgn:field cgn:name="project-id" cgn:type="long"/>
    </cgn:object>

    <cgn:object cgn:name="Model">
      <cgn:field cgn:name="used-work-packages" cgn:type="[WorkPackage]"/>
      <cgn:field cgn:name="time" cgn:type="date"/>
    </cgn:object>
  </objects>
```

The generated code is:

```java
package com.mycompany.example;



/**
 * Generated from example.xml on 30/9/2014
 */
public class WorkPackage implements android.os.Parcelable {

    private long mCustomerId;
    private long mWorkcodeId;
    private long mProjectId;

    public static class Builder {

        private long mCustomerId;
        private long mWorkcodeId;
        private long mProjectId;

        public Builder() {
        }

        public Builder setCustomerId(long customerId) {
            this.mCustomerId = customerId;
            return this;
        }

        public Builder setWorkcodeId(long workcodeId) {
            this.mWorkcodeId = workcodeId;
            return this;
        }

        public Builder setProjectId(long projectId) {
            this.mProjectId = projectId;
            return this;
        }

        public WorkPackage create() {
            return new WorkPackage(mCustomerId, mWorkcodeId, mProjectId);
        }
    }

    public WorkPackage(long customerId, long workcodeId, long projectId) {
        mCustomerId = customerId;
        mWorkcodeId = workcodeId;
        mProjectId = projectId;
    }

    /*
     * Implementing Parcelable interface 
     */
    public WorkPackage(android.os.Parcel in) {
        this.mCustomerId = in.readLong();
        this.mWorkcodeId = in.readLong();
        this.mProjectId = in.readLong();
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        out.writeLong(mCustomerId);
        out.writeLong(mWorkcodeId);
        out.writeLong(mProjectId);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<WorkPackage> CREATOR = new android.os.Parcelable.Creator<WorkPackage>() {
        public WorkPackage createFromParcel(android.os.Parcel in) {
            return new WorkPackage(in);
        }
        public WorkPackage[] newArray(int size) {
            return new WorkPackage[size];
        }
    };

    /*
     * Parcelable interface implementation done 
     */

    public long getCustomerId() {
        return this.mCustomerId;
    }

    public long getWorkcodeId() {
        return this.mWorkcodeId;
    }

    public long getProjectId() {
        return this.mProjectId;
    }

    public WorkPackage setCustomerId(long customerId) {
        this.mCustomerId = customerId;
        return this;
    }

    public WorkPackage setWorkcodeId(long workcodeId) {
        this.mWorkcodeId = workcodeId;
        return this;
    }

    public WorkPackage setProjectId(long projectId) {
        this.mProjectId = projectId;
        return this;
    }

}
```

and

```java
package com.mycompany.example;



/**
 * Generated from example.xml on 30/9/2014
 */
public class Model implements android.os.Parcelable {

    private java.util.ArrayList<WorkPackage> mUsedWorkPackages;
    private java.util.Date mTime;

    public static class Builder {

        private java.util.ArrayList<WorkPackage> mUsedWorkPackages;
        private java.util.Date mTime;

        public Builder() {
        }

        public Builder setUsedWorkPackages(java.util.ArrayList<WorkPackage> usedWorkPackages) {
            this.mUsedWorkPackages = usedWorkPackages;
            return this;
        }

        public Builder setTime(java.util.Date time) {
            this.mTime = time;
            return this;
        }

        public Model create() {
            return new Model(mUsedWorkPackages, mTime);
        }
    }

    public Model(java.util.ArrayList<WorkPackage> usedWorkPackages, java.util.Date time) {
        mUsedWorkPackages = usedWorkPackages;
        mTime = time;
    }

    /*
     * Implementing Parcelable interface 
     */
    public Model(android.os.Parcel in) {
        this.mUsedWorkPackages = new java.util.ArrayList<WorkPackage>();  in.readTypedList(mUsedWorkPackages, WorkPackage.CREATOR);
        this.mTime = (java.util.Date)in.readSerializable();
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        out.writeTypedList(mUsedWorkPackages);
        out.writeSerializable(mTime);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<Model> CREATOR = new android.os.Parcelable.Creator<Model>() {
        public Model createFromParcel(android.os.Parcel in) {
            return new Model(in);
        }
        public Model[] newArray(int size) {
            return new Model[size];
        }
    };

    /*
     * Parcelable interface implementation done 
     */

    public java.util.ArrayList<WorkPackage> getUsedWorkPackages() {
        return this.mUsedWorkPackages;
    }

    public java.util.Date getTime() {
        return this.mTime;
    }

    public Model setUsedWorkPackages(java.util.ArrayList<WorkPackage> usedWorkPackages) {
        this.mUsedWorkPackages = usedWorkPackages;
        return this;
    }

    public Model setTime(java.util.Date time) {
        this.mTime = time;
        return this;
    }

}
```
