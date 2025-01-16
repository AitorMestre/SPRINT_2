#1 Llistat dels països que estan fent compres.
SELECT 
    c.country AS paisos
FROM
    company c
        INNER JOIN
    transaction t ON c.id = t.company_id
GROUP BY c.country;

#2 Des de quants països es realitzen les compres.
SELECT 
    COUNT(DISTINCT country)
FROM
    company;
    
    #3Identifica la companyia amb la mitjana més gran de vendes.
 SELECT 
    c.company_name AS nom_de_la_companyia,
    AVG(t.amount) AS mitjana_vendes
FROM
    company c
        INNER JOIN
    transaction t ON c.id = t.company_id
GROUP BY c.company_name
ORDER BY mitjana_vendes desc
LIMIT 1;

#3.1 Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT 
    *
FROM
    transaction
WHERE
    company_id IN (SELECT 
            id
        FROM
            company
        WHERE
            country = 'Germany');

#3.2Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT DISTINCT company_name
FROM company
WHERE id IN (
    SELECT company_id
    FROM transaction
    WHERE amount > (
        SELECT AVG(amount)
        FROM transaction
    )
)
ORDER BY company_name;

#3.3 Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT company_name
FROM company
WHERE id NOT IN (
    SELECT  company_id
    FROM transaction
);

#4.1 Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes.
# Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT 
    DATE(timestamp) AS data, SUM(amount) AS total_vendes
FROM
    transaction
GROUP BY DATE(timestamp)
ORDER BY total_vendes DESC
LIMIT 5;

#4.2Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT c.country, AVG(t.amount) as mitjana_vendes
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.country
ORDER BY mitjana_vendes DESC;

#4.3En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". 
#Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

select c.company_name as empresa,count(t.company_id) as numero_transaccions,c.country as pais
from company c
join transaction t
on c.id = t.company_id
where c.country like 'United Kingdom'
group by empresa,pais;

#4.3Mostra el llistat aplicant solament subconsultes.

SELECT 
    company_name AS empresa,
    country AS pais,
    (SELECT 
            COUNT(*)
        FROM
            transaction
        WHERE
            company_id = company.id) AS numero_transaccions
FROM
    company
WHERE
    country LIKE 'United Kingdom'
        AND id IN (SELECT DISTINCT
            company_id
        FROM
            transaction);
