/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.example.parser;

import java.text.ParseException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Date;
import java.util.Map;
import java.util.HashMap;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonToken;
import java.io.IOException;

/**
 * Generated from java_objects_test1.xml on 15/6/2015
 */
public class ObjectsParser {

    /**
     * Parses the date/time string into the Joda DateTime object.
     * @param dateString the string containing the date/time to parse
     * @return org.joda.time.DateTime object with the parsed date/time
     */
    public static org.joda.time.DateTime parseISODate(String dateString) throws IOException {
        org.joda.time.DateTime date = null;
        try {
           date = org.joda.time.format.ISODateTimeFormat.dateTimeParser().parseDateTime(dateString);
        } catch (UnsupportedOperationException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        } catch (IllegalArgumentException e) {
            throw new IOException("Unable to parse date: ".concat(dateString));
        }
        return date;
    }

    public static com.arrays.test.CommandLine parse(JsonParser parser, com.arrays.test.CommandLine commandLine) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.arrays.test.CommandLine is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("executable".equals(currentName)) /* parse "executable" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.CommandLine::executable is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    commandLine.setExecutable(parser.getText());
                }
            }
            else if ("arguments".equals(currentName)) /* parse "arguments" of type java.util.ArrayList<String> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.CommandLine::arguments is not of type [string]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<String> array = new java.util.ArrayList<String>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.CommandLine::arguments[i] is not of type string");
                        array.add(parser.getText());
                    }
                    /* call the setter and set field value */
                    commandLine.setArguments(array);
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return commandLine;
    }

    public static com.arrays.test.FieldsTest parse(JsonParser parser, com.arrays.test.FieldsTest fieldsTest) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.arrays.test.FieldsTest is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("0field00".equals(currentName)) /* parse "0field00" of type com.arrays.test.CommandLineVersion1 */ {
                /* type verification, either NULL or JsonToken.START_OBJECT */
                if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::0field00 is not of type com.arrays.test.CommandLineVersion1");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    fieldsTest.set0field00(null);
                }
            }
            else if ("1field01".equals(currentName)) /* parse "1field01" of type com.arrays.test.CommandLineVersion2 */ {
                /* type verification, either NULL or JsonToken.START_OBJECT */
                if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::1field01 is not of type com.arrays.test.CommandLineVersion2");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    fieldsTest.set1field01(null);
                }
            }
            else if ("field1".equals(currentName)) /* parse "field1" of type com.arrays.test.CommandLine */ {
                /* type verification, either NULL or JsonToken.START_OBJECT */
                if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::field1 is not of type com.arrays.test.CommandLine");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    fieldsTest.setField1(ObjectsParser.parse(parser, new com.arrays.test.CommandLine()));
                }
            }
            else if ("field2".equals(currentName)) /* parse "field2" of type com.arrays.test.CommandLine */ {
                /* type verification, either NULL or JsonToken.START_OBJECT */
                if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::field2 is not of type com.arrays.test.CommandLine");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    fieldsTest.setField2(ObjectsParser.parse(parser, new com.arrays.test.CommandLine()));
                }
            }
            else if ("field3".equals(currentName)) /* parse "field3" of type com.structs.WorkPackage */ {
                /* type verification, either NULL or JsonToken.START_OBJECT */
                if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::field3 is not of type com.structs.WorkPackage");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    fieldsTest.setField3();
                }
            }
            else if ("array1".equals(currentName)) /* parse "array1" of type java.util.ArrayList<com.arrays.test.CommandLine> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::array1 is not of type [com.arrays.test.CommandLine]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<com.arrays.test.CommandLine> array = new java.util.ArrayList<com.arrays.test.CommandLine>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::array1[i] is not of type com.arrays.test.CommandLine");
                        array.add(ObjectsParser.parse(parser, new com.arrays.test.CommandLine()));
                    }
                    /* call the setter and set field value */
                    fieldsTest.setArray1(array);
                }
            }
            else if ("array2".equals(currentName)) /* parse "array2" of type java.util.ArrayList<com.arrays.test.CommandLine> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::array2 is not of type [com.arrays.test.CommandLine]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<com.arrays.test.CommandLine> array = new java.util.ArrayList<com.arrays.test.CommandLine>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::array2[i] is not of type com.arrays.test.CommandLine");
                        array.add(ObjectsParser.parse(parser, new com.arrays.test.CommandLine()));
                    }
                    /* call the setter and set field value */
                    fieldsTest.setArray2(array);
                }
            }
            else if ("array3".equals(currentName)) /* parse "array3" of type java.util.ArrayList<com.structs.test.WorkPackage> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::array3 is not of type [com.structs.test.WorkPackage]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<com.structs.test.WorkPackage> array = new java.util.ArrayList<com.structs.test.WorkPackage>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.START_OBJECT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.arrays.test.FieldsTest::array3[i] is not of type com.structs.test.WorkPackage");
                        array.add(null);
                    }
                    /* call the setter and set field value */
                    fieldsTest.setArray3(array);
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return fieldsTest;
    }

    public static com.arrays.test.EmptyObject parse(JsonParser parser, com.arrays.test.EmptyObject emptyObject) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.arrays.test.EmptyObject is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            /* unknown element. Call skipChildren() if the element is an array or object */
            parser.skipChildren();
        }

        return emptyObject;
    }

    public static com.mycompany.users.PersonalUserData parse(JsonParser parser, com.mycompany.users.PersonalUserData personalUserData) throws IOException {
        /* object should start with the START_OBJECT token */
        if (parser.getCurrentToken() != JsonToken.START_OBJECT) throw new IOException("Json node for com.mycompany.users.PersonalUserData is not a Json Object");

        /* loop through all fields of the object */
        while(parser.nextValue() != JsonToken.END_OBJECT) {
            if (!parser.hasCurrentToken()) throw new IOException("Malformed JSON");
            final String currentName = parser.getCurrentName();

            if ("name".equals(currentName)) /* parse "name" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.users.PersonalUserData::name is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    personalUserData.setName(parser.getText());
                }
            }
            else if ("occupation".equals(currentName)) /* parse "occupation" of type String */ {
                /* type verification, either NULL or JsonToken.VALUE_STRING */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.users.PersonalUserData::occupation is not of type string");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    personalUserData.setOccupation(parser.getText());
                }
            }
            else if ("age".equals(currentName)) /* parse "age" of type int */ {
                /* type verification, either NULL or JsonToken.VALUE_NUMBER_INT */
                if (!(parser.getCurrentToken() == JsonToken.VALUE_NUMBER_INT || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.users.PersonalUserData::age is not of type int");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* call the setter and set field value */
                    personalUserData.setAge(parser.getValueAsInt());
                }
            }
            else if ("visits".equals(currentName)) /* parse "visits" of type java.util.ArrayList<org.joda.time.DateTime> */ {
                /* type verification, either NULL or JsonToken.START_ARRAY */
                if (!(parser.getCurrentToken() == JsonToken.START_ARRAY || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.users.PersonalUserData::visits is not of type [date]");
                /* if not NULL try to parse */
                if (parser.getCurrentToken() != JsonToken.VALUE_NULL) {
                    /* Create the array */
                    java.util.ArrayList<org.joda.time.DateTime> array = new java.util.ArrayList<org.joda.time.DateTime>();
                    /* Loop until the end of the array */
                    while (parser.nextToken() != JsonToken.END_ARRAY) {
                        /* We expect not null elements of correct type */
                        if (!(parser.getCurrentToken() == JsonToken.VALUE_STRING || parser.getCurrentToken() == JsonToken.VALUE_NULL)) throw new IOException("Json node for com.mycompany.users.PersonalUserData::visits[i] is not of type date");
                        array.add(parseISODate(parser.getText()));
                    }
                    /* call the setter and set field value */
                    personalUserData.setVisits(array);
                }
            }
            else {
                /* unknown element. Call skipChildren() if the element is an array or object */
                parser.skipChildren();
            }
        }

        return personalUserData;
    }

}
