SELECT
	TOP 100 *
FROM
	FactOnlineSales

---- FATURAMENTO ----

SELECT
	FORMAT(SUM(SalesAmount),'c', 'en-US') AS 'Faturamento_Total'
FROM
	FactOnlineSales

SELECT
	YEAR(DateKey) AS 'Ano',
	FORMAT(SUM(SalesAmount), 'c', 'en-US') AS 'Faturamento_Anual'
FROM
	FactOnlineSales
GROUP BY YEAR(DateKey)

SELECT
	FORMAT(MONTH(DateKey),'MMMM') AS 'Mês',
	FORMAT(SUM(SalesAmount), 'c', 'en-US') AS 'Faturamento_Mensal'
FROM
	FactOnlineSales
GROUP BY MONTH(DateKey)

--- FATURAMENTO POR LOJA ----

SELECT
	DimStore.StoreName,
	FORMAT(SUM(SalesAmount), 'c', 'en-us') AS 'Faturamento'
FROM
	FactOnlineSales
INNER JOIN DimStore
	ON DimStore.StoreKey = FactOnlineSales.StoreKey
GROUP BY DimStore.StoreName
ORDER BY FORMAT(SUM(SalesAmount), 'c', 'en-us')


SELECT
	DimStore.StoreName,
	FORMAT(SUM(SalesQuantity), 'c', 'en-us') AS 'QTD_VENDAS'
FROM
	FactOnlineSales
INNER JOIN DimStore
	ON DimStore.StoreKey = FactOnlineSales.StoreKey
GROUP BY DimStore.StoreName
ORDER BY FORMAT(SUM(SalesQuantity), 'c', 'en-us')


---- FATURAMENTO POR PRODUTOS ----
SELECT
	DimProduct.ProductName,
	FORMAT(SUM(SalesAmount), 'c',  'en-US') AS 'Faturamento'
FROM
	FactOnlineSales
INNER JOIN DimProduct
	ON DimProduct.ProductKey = FactonlineSales.ProductKey
GROUP BY DimProduct.ProductName
ORDER BY FORMAT(SUM(SalesAmount), 'c',  'en-US')

---- LUCRO ---
SELECT
	FORMAT(SUM(SalesAmount) - (SUM(TotalCost) + SUM(DiscountAmount)), 'c', 'en-US') AS 'Lucro'
FROM
	FactonlineSales

SELECT 
    SUM(SalesAmount)                              AS total_vendas,
    SUM(TotalCost)                                AS total_custos,
    SUM(DiscountAmount)                           AS total_descontos,
    FORMAT(SUM(SalesAmount - TotalCost - DiscountAmount), 'c', 'en-US') AS lucro_total
FROM FactonlineSales

SELECT 
    p.ProductName AS produto,
    FORMAT(SUM(s.SalesAmount),'C','en-US')                              AS vendas,
    FORMAT(SUM(s.TotalCost), 'c', 'en-US')                                 AS custos,
    FORMAT(SUM(s.DiscountAmount),'c', 'en-US')                           AS descontos,
    FORMAT(SUM(s.SalesAmount - s.TotalCost - s.DiscountAmount), 'c', 'en-US') AS lucro
FROM dbo.FactSales s
INNER JOIN dbo.DimProduct p 
    ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName
ORDER BY lucro DESC

SELECT 
    p.ProductName AS produto,
    FORMAT(SUM(s.SalesAmount), 'c', 'en-US') AS vendas,
    FORMAT(SUM(s.SalesAmount - s.TotalCost - s.DiscountAmount), 'c', 'en-US') AS lucro,
    ROUND(
        SUM(s.SalesAmount - s.TotalCost - s.DiscountAmount) * 100.0 
        / NULLIF(SUM(s.SalesAmount), 0), 
    2) AS margem_percentual
FROM dbo.FactSales s
INNER JOIN dbo.DimProduct p 
    ON s.ProductKey = p.ProductKey
GROUP BY p.ProductName
ORDER BY lucro DESC;

