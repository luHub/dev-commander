runtime! syntax/sql.vim
unlet! b:current_syntax
syn case ignore

" Core GoogleSQL Keywords
syn keyword spannerKeyword INTERLEAVE PARENT CASCADE ACTION DELETE
syn keyword spannerKeyword UNNEST STRUCT ARRAY PROTO ENUM
syn keyword spannerKeyword TABLESAMPLE BERNOULLI SYSTEM
syn keyword spannerKeyword NULL_FILTERED STORING
syn keyword spannerKeyword FORCE_INDEX GROUPBY_SCAN_OPTIMIZATION
syn keyword spannerKeyword ASSERT_ROWS_MODIFIED DEFINE

" Spanner DDL, Schema, TTL, Sequences & Vector Search
syn keyword spannerDDL ALTER TABLE INDEX VIEW DATABASE ROLE SEQUENCE
syn keyword spannerDDL CHANGE STREAM VECTOR SEARCH ANALYZE
syn keyword spannerDDL OPTIONS ALLOW_COMMIT_TIMESTAMP HIDDEN GENERATED STORED
syn keyword spannerDDL ROW DELETION POLICY OLDER_THAN
syn keyword spannerDDL BIT_REVERSED_POSITIVE SKIP_RANGE_MIN SKIP_RANGE_MAX START_WITH_COUNTER
syn keyword spannerDDL DISTANCE_TYPE COSINE EUCLIDEAN DOT_PRODUCT

" Spanner Graph (GQL) Keywords
syn keyword spannerGraph GRAPH GRAPH_TABLE PROPERTY NODE EDGE LABEL
syn keyword spannerGraph MATCH RETURN PATH SHORTEST CHEAPEST WALK TRAIL ACYCLIC SIMPLE
syn keyword spannerGraph SOURCE DESTINATION REFERENCES ELEMENT_TABLE

" Spanner Data Types
syn keyword spannerType BOOL INT64 FLOAT32 FLOAT64 NUMERIC BIGNUMERIC
syn keyword spannerType STRING BYTES DATE TIMESTAMP JSON TOKENLIST

" Built-in Functions: UUID & System
syn keyword spannerFunction NEW_UUID GENERATE_UUID PENDING_COMMIT_TIMESTAMP GET_INTERNAL_SEQUENCE_STATE

" Built-in Functions: Timestamp & Date
syn keyword spannerFunction CURRENT_DATE CURRENT_TIMESTAMP EXTRACT
syn keyword spannerFunction DATE DATE_ADD DATE_SUB DATE_DIFF DATE_TRUNC DATE_FROM_UNIX_DATE UNIX_DATE
syn keyword spannerFunction TIMESTAMP TIMESTAMP_ADD TIMESTAMP_SUB TIMESTAMP_DIFF TIMESTAMP_TRUNC
syn keyword spannerFunction TIMESTAMP_SECONDS TIMESTAMP_MILLIS TIMESTAMP_MICROS
syn keyword spannerFunction UNIX_SECONDS UNIX_MILLIS UNIX_MICROS FORMAT_DATE FORMAT_TIMESTAMP PARSE_DATE PARSE_TIMESTAMP

" Built-in Functions: JSON
syn keyword spannerFunction PARSE_JSON TO_JSON TO_JSON_STRING JSON_TYPE
syn keyword spannerFunction JSON_QUERY JSON_VALUE JSON_QUERY_ARRAY JSON_VALUE_ARRAY
syn keyword spannerFunction LAX_BOOL LAX_INT64 LAX_FLOAT64 LAX_STRING
syn keyword spannerFunction JSON_SET JSON_INSERT JSON_REPLACE JSON_STRIP_NULLS JSON_REMOVE JSON_ARRAY JSON_OBJECT

" Built-in Functions: Array & Struct
syn keyword spannerFunction ARRAY_CONCAT ARRAY_LENGTH ARRAY_TO_STRING GENERATE_ARRAY GENERATE_DATE_ARRAY

" Built-in Functions: String & Bytes
syn keyword spannerFunction BYTE_LENGTH CHAR_LENGTH CHARACTER_LENGTH CONCAT ENDS_WITH STARTS_WITH
syn keyword spannerFunction FORMAT FROM_BASE64 TO_BASE64 FROM_HEX TO_HEX
syn keyword spannerFunction LENGTH LOWER UPPER LTRIM RTRIM TRIM
syn keyword spannerFunction REGEXP_CONTAINS REGEXP_EXTRACT REGEXP_EXTRACT_ALL REGEXP_REPLACE
syn keyword spannerFunction REPEAT REPLACE REVERSE SPLIT STRPOS SUBSTR

" Built-in Functions: Math, Aggregate & Conditional
syn keyword spannerFunction ABS SIGN IS_INF IS_NAN IEEE_DIVIDE SAFE_DIVIDE SAFE_ADD SAFE_SUBTRACT SAFE_MULTIPLY SAFE_NEGATE
syn keyword spannerFunction GREATEST LEAST MOD POW POWER SQRT EXP LN LOG LOG10 CEIL CEILING FLOOR ROUND TRUNC
syn keyword spannerFunction ANY_VALUE ARRAY_AGG AVG BIT_AND BIT_OR BIT_XOR COUNT COUNTIF MAX MIN STRING_AGG SUM
syn keyword spannerFunction COALESCE IF IFNULL NULLIF SAFE_CAST

" Built-in Functions: Full-Text & Vector Search
syn keyword spannerFunction TOKENIZE_FULLTEXT TOKENIZE_SUBSTRING TOKENIZE_NGRAMS TOKENIZE_NUMBER TOKENIZE_BOOL TOKENLIST_CONCAT
syn keyword spannerFunction SEARCH SEARCH_SUBSTRING SEARCH_NGRAMS SCORE SCORE_NGRAMS SNIPPET
syn keyword spannerFunction COSINE_DISTANCE EUCLIDEAN_DISTANCE DOT_PRODUCT APPROX_COSINE_DISTANCE APPROX_EUCLIDEAN_DISTANCE APPROX_DOT_PRODUCT

" GoogleSQL Strings, Backtick Identifiers, Parameters, Hints & Comments
syn region spannerString start=+[rRbB]\?"""+ end=+"""+
syn region spannerString start=+[rRbB]\?'''+ end=+'''+
syn region spannerString start=+[rRbB]\?"+ skip=+\\"+ end=+"+
syn region spannerString start=+[rRbB]\?'+ skip=+\\'+ end=+'+
syn region spannerIdentifier start="`" end="`"
syn match spannerParam "@[a-zA-Z_][a-zA-Z0-9_]*"
syn region spannerHint start="@{" end="}" contains=spannerKeyword,spannerDDL,spannerString
syn match spannerComment "#.*$"

" Highlight Group Links
hi def link spannerKeyword Statement
hi def link spannerDDL PreProc
hi def link spannerGraph Keyword
hi def link spannerType Type
hi def link spannerFunction Function
hi def link spannerString String
hi def link spannerIdentifier Identifier
hi def link spannerParam Constant
hi def link spannerHint Special
hi def link spannerComment Comment

let b:current_syntax = "spanner"

" Recent Spanner Functions (UUID, Sequences, Arrays, Intervals, ML/AI)
syn keyword spannerFunction NEW_UUID GET_NEXT_SEQUENCE_VALUE GET_INTERNAL_SEQUENCE_STATE
syn keyword spannerFunction ARRAY_INCLUDES ARRAY_INCLUDES_ALL ARRAY_INCLUDES_ANY ARRAY_MIN ARRAY_MAX
syn keyword spannerFunction ARRAY_FILTER ARRAY_TRANSFORM ARRAY_FIRST ARRAY_LAST ARRAY_SLICE
syn keyword spannerFunction MAKE_INTERVAL JUSTIFY_DAYS JUSTIFY_HOURS JUSTIFY_INTERVAL
syn keyword spannerFunction ML_PREDICT ML_GENERATE_TEXT
syn match spannerFunction "\<\(AI\.\(CLASSIFY\|IF\|SCORE\)\|HLL_COUNT\.\(INIT\|MERGE\|MERGE_PARTIAL\|EXTRACT\)\)\>"

" Recent Spanner Data Types (2025-2026)
syn keyword spannerType UUID INTERVAL GRAPH_ELEMENT GRAPH_NODE GRAPH_EDGE GRAPH_PATH

" Recent Spanner DDL & Schema Objects (Locality Groups, Queues, Identity, Bundles)
syn keyword spannerDDL LOCALITY GROUP PLACEMENT PROTO BUNDLE QUEUE SYNONYM
syn keyword spannerDDL IDENTITY ENFORCED CONFLICT NOTHING RETURN RETURNING
syn keyword spannerDDLTTL MAX_STALENESS

" Recent Spanner Approximate Aggregate Functions
syn keyword spannerFunction APPROX_COUNT_DISTINCT APPROX_QUANTILES APPROX_TOP_COUNT APPROX_TOP_SUM
