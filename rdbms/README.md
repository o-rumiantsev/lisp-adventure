# LiSQL (Lisp SQL)

Document-oriented DBMS with SQL-like query syntax written
in Lisp without any variable.

#### Startup

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

#### Commands

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


##### EXIT

Closes CLI

```
> EXIT
bye
```

##### SAVE

Saves current database context to file

```
> SAVE "db.data"
Saved db to "db.data"
```

##### LOAD

Loads database context from file

```
> LOAD "db.data"
Loaded db from "db.data"
```

##### LIST TABLES

List all tables' names from current database context

```
> LIST TABLES
EXAMPLE1
EXAMPLE2
EXAMPLE3
```

##### CREATE TABLE

Create table in current database context

```
> CREATE TABLE example1 (
    (number-field number)
    (string-field string)
    (bool-field     bool)
)
CREATED TABLE EXAMPLE1
```

__*Note*__: Table schema is a list of lists, where each list is
a field definition. First item of field definition is 
field name, and second is field's type: `((<name> <type>) ...)`

##### DROP TABLE

Drop table in current database context

```
> DROP TABLE example1
DROPPED TABLE EXAMPLE1
```

##### SELECT

Select rows from table in current database context

```
> SELECT example1 (> number-field 10) ((string-field asc))
(NUMBER-FIELD STRING-FIELD BOOL-FIELD)
(20 "string1" t)
(15 "string2" nil)
(25 "string3" t)
```

__*Note*__: Conditions is a composition of logical functions,
which might return `t` or `nil`. One more feature here is field
names in conditions. It works so: for every row in table there
are field names substituted by appropriate values in row and
condition is evaluated. So for row `(10 "string0" t)` and 
schema `(number-field string-field bool-field)` condition
`(> number-field 10)` will be `(> 10 10)` and will evaluate 
to `nil`

__*Note*__: Ordering is a list of lists - order definitions.
Order definition has a first list item as a field name and second, optional,
list item as an sorting order(`desc` for descending, `asc` 
for ascending, default).
