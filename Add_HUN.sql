/************************************************************
    Author  :   Ferenc Toth
    Remark  :   Adding Hungarian to MULTILANG
    Date    :   2015.07.01
************************************************************/


Prompt *****************************************************************
Prompt **               A D D I N G   H U N G A R I A N               **
Prompt *****************************************************************

INSERT INTO ML_LANGUAGES ( ID, CODE, TEXT, IS_DEFAULT ) VALUES ( 1, 'HUN', 'Magyar', 'Y' );

INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  1, 1,  1, 'BINARY'                       );     -- NLS_COMP
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  2, 1,  2, 'HUNGARIAN'                    );     -- NLS_SORT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  3, 1,  3, 'GREGORIAN'                    );     -- NLS_CALENDAR
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  4, 1,  4, 'HUNGARIAN'                    );     -- NLS_LANGUAGE
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  5, 1,  5, 'HUNGARY'                      );     -- NLS_TERRITORY
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  6, 1,  6, 'YYYY.MM.DD'                   );     -- NLS_DATE_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  7, 1,  7, 'HH24:MI:SSXFF'                );     -- NLS_TIME_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  8, 1,  8, 'YYYY.MM.DD HH24:MI:SSXFF'     );     -- NLS_TIMESTAMP_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES (  9, 1,  9, 'YYYY.MM.DD HH24:MI:SSXFF TZR' );     -- NLS_TIMESTAMP_TZ_FORMAT
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 10, 1, 10, 'HUNGARIAN'                    );     -- NLS_DATE_LANGUAGE   
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 11, 1, 11, 'Ft'                           );     -- NLS_CURRENCY      
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 12, 1, 12, 'HUNGARY'                      );     -- NLS_ISO_CURRENCY
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 13, 1, 13, 'Ft'                           );     -- NLS_DUAL_CURRENCY
INSERT INTO ML_NLS_SETTINGS( ID , LANGUAGE_ID, NLS_PARAMETER_ID, SETTING )  VALUES ( 14, 1, 14, '. '                           );     -- NLS_NUMERIC_CHARACTERS

COMMIT;

