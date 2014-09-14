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

The first object, ***PersonalUserData***, will have setters and will have a JSON-parser generated. If the field doesn't have a type, the **string** type assumed. One can see how to define arrays as types as well - using square brackets as in **visits** field. 

The second object will not have any setters, however the [Builder](http://en.wikipedia.org/wiki/Builder_pattern) inner class will be generated. The object as well will implement Android's [Parcelable](http://developer.android.com/reference/android/os/Parcelable.html) interface. One can see how the previously defined object can be used as a field type.


See the the [example.xml](https://github.com/fourier/cgn/blob/master/examples/example.xml) in ***examples*** directory for the example and descriptions of all possible fields.
To use the ***example.xml*** to generate sources, go to the ***examples*** directory and run
<pre>
./genpojos_and_parser.sh
</pre>

It will generate the ***gen*** directory with sources (POJOs and JSON parser) based on schemas in the ***example.xml*** file.
