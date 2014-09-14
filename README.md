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

See the the [example.xml](https://github.com/fourier/cgn/blob/master/examples/example.xml) in ***examples*** directory for the example and descriptions of all possible fields.
To use the ***example.xml*** to generate sources, go to the ***examples*** directory and run
<pre>
./genpojos_and_parser.sh
</pre>

It will generate the ***gen*** directory with sources (POJOs and JSON parser) based on schemas in the ***example.xml*** file.
