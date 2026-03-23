# UEK-106 SQL Cheatsheet

## SELECT
SELECT * FROM tabelle WHERE id = 1;

## JOIN
SELECT a.name, b.wert
FROM tabelle_a a
JOIN tabelle_b b ON a.id = b.a_id;
