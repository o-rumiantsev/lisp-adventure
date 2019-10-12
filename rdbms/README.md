# LiSQL (Lisp SQL)

Document-oriented DBMS with SQL-like query syntax written
in Lisp without any variable.

## Startup

```bash
$ sbcl --script cli.lsp
```

You will see the welcome message and help:

```
Welcome to LiSQL CLI

General commands:
  EXIT               close CLI
  SAVE <filename>    save db to file
  LOAD <filename>    load db from file

Database:
  LIST TABLES                              list db tables
  CREATE TABLE <name> <schema>             create table
  DROP TABLE <name>                        drop table
  SELECT <name> <conditions> <ordering>    select data from table
  INSERT INTO <name> <row>                 insert data to table
  UPDATE <name> <mappings> <conditions>    update data in table
  DELETE <name> <conditions>               delete data from table
```

## Commands

Available commands:

* [EXIT](#exit)
* [SAVE](#save)
* [LOAD](#load)
* [LIST TABLES](#list-tables)
* [CREATE TABLE](#create-table)
* [DROP TABLE](#drop-table)
* [SELECT](#select)
* [INSERT](#insert)
* [UPDATE](#update)
* [DELETE](#delete)


### EXIT

__Description__: Closes CLI

__Format__: EXIT

__Example__:

```
> EXIT
bye
```

### SAVE

__Description__: Saves current database context to file

__Format__: SAVE \<[fileaname](#string)>

__Example__:

```
> SAVE "db.data"
Saved db to "db.data"
```

### LOAD

__Description__: Loads database context from file

__Format__: LOAD \<[fileaname](#string)>

__Example__:

```
> LOAD "db.data"
Loaded db from "db.data"
```

### LIST TABLES

__Description__: List all tables' names from current database context

__Format__: LIST TABLES

__Example__:

```
> LIST TABLES
EXAMPLE1
EXAMPLE2
EXAMPLE3
```

### CREATE TABLE

__Description__: Create table in current database context

__Format__: CREATE TABLE 
    \<[table name](#symbol)>
    \<[table schema](#schema)>

__Example__:

```
> CREATE TABLE example1 (
    (number-field number)
    (string-field string)
    (bool-field     bool)
)
CREATED TABLE EXAMPLE1
```

### DROP TABLE

__Description__: Drop table in current database context

__Format__: DROP TABLE \<[table name](#symbol)>

__Example__:

```
> DROP TABLE example1
DROPPED TABLE EXAMPLE1
```

### SELECT

__Description__: Select rows from table in current database context

__Format__: SELECT 
    \<[table name](#symbol)> 
    \<[conditions](#conditions)> 
    \<[ordering](#ordering)>

__Example__:

```
> SELECT example1 (> number-field 10) ((string-field asc))
(NUMBER-FIELD STRING-FIELD BOOL-FIELD)
(20 "string1" t)
(15 "string2" nil)
(25 "string3" t)
```

### INSERT

__Description__: Insert row to table in current database context

__Format__: INSERT INTO 
    \<[table name](#symbol)>
    \<[row](#list)>

__Example__:

```
> INSERT INTO example1 (10 "string0" t)
INSERT (10 "string0" t) 
```

__*Note*__: If table schema does not accept given row, it won't
be inserted.

```
> INSERT INTO example1 ("10" "string" t)
> SELECT example1 () ()
(NUMBER-FIELD STRING-FIELD BOOL-FIELD)
(20 "string1" t)
(15 "string2" nil)
(25 "string3" t)
```

### UPDATE

__Description__: Update rows in table in current database context

__Format__: UPDATE 
    \<[table name](#symbol)>
    \<[mappings](#mappings)>
    \<[conditions](#conditions)>    

__Example__:

```
> UPDATE example1 ((bool-field t)) (not bool-field)
UPDATED (15 "string2" nil) --> (15 "string2" t)
```

__*Note*__: Mappings will be applied only for rows, which
accept given conditions

__*Note*__: If table schema is not accepting mapped row, row is 
not updated.

### DELETE

__Description__: Delete rows from table in current database context

__Format__: DELETE
    \<[table name](#symbol)>
    \<[conditions](#conditions)>

__Example__:

```
> DELETE example1 (not bool-field)
DELETED (15 "string2" nil)
```

## Definitions

#### String

Lisp string object(e.g. `"some string"`).

#### Symbol

Lisp symbol object(e.g. `some-symbol`).

#### List

Lisp list object(e.g. `(1 2 3)`).

#### Schema

Table schema is a list of lists, where each list is
a field definition. First item of field definition is 
field name, and second is field's type: `((<name> <type>) ...)`.

Valid types for table schema is: `number`, `string` and `bool`.

#### Conditions

Conditions is a composition of logical functions,
which might return `t` or `nil`. One more feature here is field
names in conditions. It works so: for every row in table there
are field names substituted by appropriate values in row and
condition is evaluated. So for row `(10 "string0" t)` and 
schema `(number-field string-field bool-field)` condition
`(> number-field 10)` will be `(> 10 10)` and will evaluate 
to `nil`.

#### Ordering

Ordering is a list of lists - order definitions.
Order definition has a first list item as a field name and second, optional,
list item as an sorting order(`desc` for descending, `asc` 
for ascending, default).

#### Mappings

Mappings is a list of lists - field map definitions.
Field map definition has a first list item as a field name
and second list item as a single value to set to the field, or 
function composition to relatively map field value. For
example `(bool-field t)` means, that `bool-field` of the row
will be set to `t`, and `(number-field (+ number-field 10))` means,
that `number-field` of the row will be increased by `10`.
