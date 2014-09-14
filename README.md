Code generator (cgn)
====================
This projec makes it simple to generate POJOs and Json parser (based on [jackson](https://github.com/FasterXML/jackson)) using [Saxon HE](http://saxon.sourceforge.net/) XSL processor.

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

To see usage example, go to ***examples*** directory and run
<pre>
./genpojos_and_parser.sh
</pre>

It will generate the ***gen*** directory with sources based on schemas in ***example.xml*** file.

