select 
	top(100)* 
from FactSales

---Ticket Médio---
select 
	FORMAT(AVG(UnitPrice), 'C', 'EN-us') AS 'Ticket Médio' 
from FactSales

---Faturamento Total---
Select 
	FORMAT(SUM(SalesAmount),'c','en-US') AS 'Faturamento' 
from FactSales

---Faturamento Mês-Ano -----
SELECT
	FORMAT(DateKey, 'MMMM','en-US') AS 'Mês',
	YEAR(Datekey) AS 'Ano',
	FORMAT(SUM(SalesAmount),'c','en-US') as 'Faturamento Mês-Ano'
FROM FactSales
GROUP BY FORMAT(DateKey, 'MMMM', 'en-US'), YEAR(Datekey) Order By FORMAT(SUM(SalesAmount),'c','en-US') DESC

--- Faturamento Anual ---
SELECT
	YEAR(DateKey) as 'Ano',
	FORMAT(SUM(SalesAmount),'c','en-US') as 'Faturamento Mensal'
FROM FactSales
GROUP BY YEAR(DateKey)

--- Faturamento Mensal ---
SELECT
	FORMAT(DateKey, 'MMMM', 'en-US') as 'Mês',
	FORMAT(SUM(SalesAmount),'c','en-US') as 'Faturamento Mensal'
FROM FactSales
GROUP BY FORMAT(DateKey, 'MMMM', 'en-US') Order BY FORMAT(SUM(SalesAmount),'c','en-US') DESC

--- Produtos mais vendidos em faturamento e quantidade
SELECT
	*
FROM DimProduct

SELECT
	DimProduct.ProductKey,
	DimProduct.ProductName,
	FORMAT(SUM(FactSales.SalesAmount), 'c', 'en-US') AS 'Faturamento',
	SUM(FactSales.SalesQuantity) AS 'Quantidade Vendida'
FROM FactSales
INNER JOIN DimProduct
	ON DimProduct.ProductKey = FactSales.ProductKey
GROUP BY DimProduct.ProductKey, DimProduct.ProductName
ORDER BY SUM(FactSales.SalesAmount) DESC

--- Análise de Custos ---
SELECT
	DimProduct.ProductKey,
	DimProduct.ProductName,
	FORMAT(SUM(FactSales.TotalCost), 'c', 'en-US') AS 'Custo_Total'
FROM FactSales
INNER JOIN DimProduct
	ON DimProduct.ProductKey = FactSales.ProductKey
GROUP BY DimProduct.ProductKey, DimProduct.ProductName
ORDER BY FORMAT(SUM(FactSales.TotalCost), 'c', 'en-US') DESC

SELECT
	YEAR(DateKey) AS 'Ano',
	MONTH(DateKey) AS 'Mês',
	FORMAT(SUM(TotalCost), 'c', 'en-US') AS 'Custo_total'
FROM FactSales
GROUP BY YEAR(DateKey), MONTH(DateKey)
ORDER BY FORMAT(SUM(TotalCost), 'c', 'en-US') DESC

--- Análise de Descontos ---
SELECT
	YEAR(Datekey) AS 'Ano',
	FORMAT(DateKey,'MMMM') AS 'Mês',
	FORMAT(SUM(DiscountAmount),'c','en-US') AS 'Desconto_Total'
FROM
	FactSales
GROUP BY YEAR(Datekey),FORMAT(DateKey,'MMMM')
ORDER BY FORMAT(SUM(DiscountAmount),'c','en-US') DESC

--- Análise de Lojas---
select * from DimStore
select * from DimGeography

SELECT
	DimStore.StoreName,
	FORMAT(SUM(FactSales.SalesAmount),'c','en-US') AS 'Faturamento'
FROM
	FactSales
INNER JOIN DimStore
	ON DimStore.StoreKey=FactSales.StoreKey
GROUP BY DimStore.StoreName
ORDER BY FORMAT(SUM(FactSales.SalesAmount),'c','en-US') DESC

SELECT
	DimGeography.ContinentName,
	FORMAT(SUM(FactSales.SalesAmount),'c', 'en-US') as 'Faturamento'
FROM
	FactSales
INNER JOIN DimGeography
	ON DimGeography.ContinentName = DimGeography.ContinentName
INNER JOIN DimStore
	ON DimStore.GeographyKey = DimGeography.GeographyKey
GROUP BY DimGeography.ContinentName
ORDER BY FORMAT(SUM(FactSales.SalesAmount),'c', 'en-US') DESC

SELECT
	DimGeography.RegionCountryName,
	FORMAT(SUM(FactSales.SalesAmount),'c', 'en-US') as 'Faturamento'
FROM
	FactSales
INNER JOIN DimGeography
	ON DimGeography.ContinentName = DimGeography.ContinentName
INNER JOIN DimStore
	ON DimStore.GeographyKey = DimGeography.GeographyKey
GROUP BY DimGeography.RegionCountryName
ORDER BY FORMAT(SUM(FactSales.SalesAmount),'c', 'en-US') DESC

---Análise de Clientes---
select * from DimCustomer

SELECT 
	CustomerType,
	COUNT(CustomerType) AS 'Quantidade Vendida'
FROM 
	DimCustomer
GROUP BY CustomerType

SELECT 
	Gender,
	COUNT(Gender) AS 'Quantidade Vendida'
FROM 
	DimCustomer
WHERE Gender IS NOT NULL
GROUP BY Gender

