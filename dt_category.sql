
WITH
    src_categories
    AS
    (
        SELECT cat."CategoryID",
            cat."CategoryName",
            cat."Description"
        FROM northwind_db."Categories" cat
    )
SELECT MD5(CONCAT(s."CategoryID", s."CategoryName")) AS "CategoryKey",
    s."CategoryName" AS "CategoryName",
    s."Description" AS "Description"
FROM src_categories s