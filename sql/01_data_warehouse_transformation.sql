USE [E-commerce-altered];
GO

CREATE TABLE feedback (
    [feedback_id] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [order_id] NVARCHAR(50) NOT NULL,
    [feedback_score] TINYINT NOT NULL CHECK([feedback_score] BETWEEN 0 AND 5),
    [feedback_form_sent_date] DATETIME NOT NULL,
    [feedback_answer_date] DATETIME NULL
);
GO

WITH CleanData AS (
    SELECT 
        [feedback_id],
        [order_id],
        [feedback_score],
        [feedback_form_sent_date],
        [feedback_answer_date],
        ROW_NUMBER() OVER (PARTITION BY [feedback_id] ORDER BY [feedback_form_sent_date] DESC) AS rowdata
    FROM [E-commerce].dbo.feedback_dataset
    WHERE [feedback_id] IS NOT NULL 
      AND [order_id] IS NOT NULL 
      AND [feedback_score] IS NOT NULL 
      AND [feedback_form_sent_date] IS NOT NULL
      AND [feedback_score] BETWEEN 0 AND 5
)
INSERT INTO [feedback] (
    [feedback_id],
    [order_id],
    [feedback_score],
    [feedback_form_sent_date],
    [feedback_answer_date]
)
SELECT 
    CAST([feedback_id] AS NVARCHAR(50)),
    CAST([order_id] AS NVARCHAR(50)),
    CAST([feedback_score] AS TINYINT),
    CAST([feedback_form_sent_date] AS DATETIME),
    CAST([feedback_answer_date] AS DATETIME)
FROM CleanData
WHERE rowdata = 1;
GO


CREATE TABLE [Users] (
    [user_name] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [customer_zip_code_prefix] INT NOT NULL,
    [customer_city] NVARCHAR(100) NOT NULL,
    [customer_state] NVARCHAR(50) NOT NULL
);
GO

WITH CleanData AS (
    SELECT 
        TRIM([user_name]) AS [user_name],
        [customer_zip_code] AS [customer_zip_code_prefix],
        TRIM([customer_city]) AS [customer_city],
        TRIM([customer_state]) AS [customer_state],
        ROW_NUMBER() OVER (
            PARTITION BY [user_name] 
            ORDER BY [customer_zip_code] ASC
        ) AS rowdata
    FROM [E-commerce].dbo.user_dataset 
    WHERE 
        [user_name] IS NOT NULL 
        AND [customer_zip_code] IS NOT NULL
        AND [customer_city] IS NOT NULL 
        AND [customer_state] IS NOT NULL 
)
INSERT INTO [Users] (
    [user_name],
    [customer_zip_code_prefix],
    [customer_city],
    [customer_state]
)
SELECT 
    CAST([user_name] AS NVARCHAR(50)),
    CAST([customer_zip_code_prefix] AS INT),
    CAST([customer_city] AS NVARCHAR(100)),
    CAST([customer_state] AS NVARCHAR(50))
FROM CleanData
WHERE rowdata = 1;
GO


CREATE TABLE [Orders] (
    [order_id] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [user_name] NVARCHAR(50) NOT NULL,
    [order_status] NVARCHAR(20) NOT NULL,
    [order_date] DATETIME NOT NULL,
    [order_approved_at] DATETIME NULL,
    [pickup_date] DATETIME NULL,
    [delivered_date] DATETIME NULL,
    [estimated_delivery_date] DATETIME NOT NULL
);
GO 

WITH CleanData AS (
    SELECT 
        [order_id],
        [user_name],
        [order_status],
        [order_date],
        [order_approved_date],
        [pickup_date],
        [delivered_date],
        [estimated_time_delivery],
        ROW_NUMBER() OVER (
            PARTITION BY [order_id] 
            ORDER BY [estimated_time_delivery] DESC
        ) AS rowdata
    FROM [E-commerce].dbo.order_dataset
    WHERE 
        [order_id] IS NOT NULL 
        AND [user_name] IS NOT NULL 
        AND [order_status] IS NOT NULL 
        AND [order_date] IS NOT NULL 
        AND [estimated_time_delivery] IS NOT NULL
)
INSERT INTO [Orders] (
    [order_id],
    [user_name],
    [order_status],
    [order_date],
    [order_approved_at],    
    [pickup_date],
    [delivered_date],
    [estimated_delivery_date]
)
SELECT 
    CAST([order_id] AS NVARCHAR(50)),
    CAST([user_name] AS NVARCHAR(50)),
    CAST([order_status] AS NVARCHAR(20)),
    CAST([order_date] AS DATETIME),
    CAST([order_approved_date] AS DATETIME),    
    CAST([pickup_date] AS DATETIME),
    CAST([delivered_date] AS DATETIME),
    CAST([estimated_time_delivery] AS DATETIME)  
FROM CleanData
WHERE rowdata = 1;
GO 


CREATE TABLE [Products] (
    [product_id] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [product_category_name] NVARCHAR(100) NULL,
    [product_name_length] INT NULL CHECK ([product_name_length] >= 0),
    [product_description_length] INT NULL CHECK ([product_description_length] >= 0),
    [product_photos_qty] INT NULL CHECK ([product_photos_qty] >= 0),
    [product_weight_g] INT NULL CHECK ([product_weight_g] >= 0),
    [product_length_cm] INT NULL CHECK ([product_length_cm] >= 0),
    [product_height_cm] INT NULL CHECK ([product_height_cm] >= 0),
    [product_width_cm] INT NULL CHECK ([product_width_cm] >= 0)
);
GO

WITH CleanData AS (
    SELECT 
        TRIM([product_id]) AS [product_id],
        TRIM([product_category]) AS [product_category_name],
        [product_name_lenght] AS [product_name_length],         
        [product_description_lenght] AS [product_description_length],
        [product_photos_qty],
        [product_weight_g],
        [product_length_cm],
        [product_height_cm],
        [product_width_cm],
        ROW_NUMBER() OVER (
            PARTITION BY [product_id] 
            ORDER BY [product_photos_qty] DESC
        ) AS rowdata
    FROM [E-commerce].dbo.products_dataset
    WHERE 
        [product_id] IS NOT NULL 
        AND TRIM([product_id]) <> ''
)
INSERT INTO [Products] (
    [product_id],
    [product_category_name],
    [product_name_length],
    [product_description_length],
    [product_photos_qty],
    [product_weight_g],
    [product_length_cm],
    [product_height_cm],
    [product_width_cm]
)
SELECT 
    CAST([product_id] AS NVARCHAR(50)),
    CAST([product_category_name] AS NVARCHAR(100)),
    CAST([product_name_length] AS INT),
    CAST([product_description_length] AS INT),
    CAST([product_photos_qty] AS INT),
    CAST([product_weight_g] AS INT),
    CAST([product_length_cm] AS INT),
    CAST([product_height_cm] AS INT),
    CAST([product_width_cm] AS INT)
FROM CleanData
WHERE rowdata = 1;
GO

-- 5. جدول Sellers
CREATE TABLE [Sellers] (
    [seller_id] NVARCHAR(50) PRIMARY KEY NOT NULL,
    [seller_zip_code_prefix] INT NOT NULL,
    [seller_city] NVARCHAR(100) NOT NULL,
    [seller_state] NVARCHAR(50) NOT NULL
);
GO

WITH CleanData AS (
    SELECT 
        TRIM([seller_id]) AS [seller_id],
        [seller_zip_code],
        TRIM([seller_city]) AS [seller_city],
        TRIM([seller_state]) AS [seller_state],
        ROW_NUMBER() OVER (
            PARTITION BY [seller_id] 
            ORDER BY [seller_zip_code] ASC
        ) AS rowdata
    FROM [E-commerce].dbo.seller_dataset 
    WHERE 
        [seller_id] IS NOT NULL
        AND [seller_zip_code] IS NOT NULL
        AND [seller_city] IS NOT NULL 
        AND [seller_state] IS NOT NULL 
)
INSERT INTO [Sellers] (
    [seller_id],
    [seller_zip_code_prefix],
    [seller_city],
    [seller_state]
)
SELECT 
    CAST([seller_id] AS NVARCHAR(50)),
    CAST([seller_zip_code] AS INT),
    CAST([seller_city] AS NVARCHAR(100)),
    CAST([seller_state] AS NVARCHAR(50))
FROM CleanData
WHERE rowdata = 1;
GO


CREATE TABLE [Order_Items] (
    [order_id] NVARCHAR(50) NOT NULL,
    [order_item_id] INT NOT NULL,
    [product_id] NVARCHAR(50) NOT NULL,
    [seller_id] NVARCHAR(50) NOT NULL,
    [pickup_limit_date] DATETIME NOT NULL,
    [price] DECIMAL(10, 2) NOT NULL CHECK ([price] >= 0),
    [shipping_cost] DECIMAL(10, 2) NOT NULL CHECK ([shipping_cost] >= 0),
    PRIMARY KEY ([order_id], [order_item_id]) 
);
GO

WITH CleanData AS (
    SELECT 
        TRIM([order_id]) AS [order_id],
        [order_item_id],
        TRIM([product_id]) AS [product_id],
        TRIM([seller_id]) AS [seller_id],
        [pickup_limit_date],
        [price],
        [shipping_cost],
        ROW_NUMBER() OVER (
            PARTITION BY [order_id], [order_item_id] 
            ORDER BY [pickup_limit_date] DESC
        ) AS rowdata
    FROM [E-commerce].dbo.order_item_dataset 
    WHERE 
        [order_id] IS NOT NULL 
        AND [order_item_id] IS NOT NULL 
        AND [product_id] IS NOT NULL 
        AND [seller_id] IS NOT NULL 
        AND [pickup_limit_date] IS NOT NULL 
        AND [price] IS NOT NULL AND [price] >= 0
        AND [shipping_cost] IS NOT NULL AND [shipping_cost] >= 0
)
INSERT INTO [Order_Items] (
    [order_id],
    [order_item_id],
    [product_id],
    [seller_id],
    [pickup_limit_date],
    [price],
    [shipping_cost]
)
SELECT 
    CAST([order_id] AS NVARCHAR(50)),
    CAST([order_item_id] AS INT),
    CAST([product_id] AS NVARCHAR(50)),
    CAST([seller_id] AS NVARCHAR(50)),
    CAST([pickup_limit_date] AS DATETIME),
    CAST([price] AS DECIMAL(10, 2)),
    CAST([shipping_cost] AS DECIMAL(10, 2))
FROM CleanData
WHERE rowdata = 1;
GO


CREATE TABLE [Order_Payments] (
    [order_id] NVARCHAR(50) NOT NULL,
    [payment_sequential] INT NOT NULL,
    [payment_type] NVARCHAR(30) NOT NULL,
    [payment_installments] INT NOT NULL CHECK ([payment_installments] >= 0),
    [payment_value] DECIMAL(10, 2) NOT NULL CHECK ([payment_value] >= 0),
    PRIMARY KEY ([order_id], [payment_sequential])
);
GO

WITH CleanData AS (
    SELECT 
        TRIM([order_id]) AS [order_id],
        payment_sequential,
        TRIM(payment_type) AS [payment_type],
        [payment_installments],
        [payment_value],
        ROW_NUMBER() OVER (
            PARTITION BY [order_id], [payment_sequential]
            ORDER BY [payment_value] DESC
        ) AS rowdata
    FROM [E-commerce].dbo.payment_dataset 
    WHERE 
        [order_id] IS NOT NULL 
        AND [payment_sequential] IS NOT NULL 
        AND [payment_type] IS NOT NULL 
        AND [payment_installments] IS NOT NULL AND [payment_installments] >= 0
        AND [payment_value] IS NOT NULL AND [payment_value] >= 0
)
INSERT INTO [Order_Payments] (
    [order_id],
    [payment_sequential],
    [payment_type],
    [payment_installments],
    [payment_value]
)
SELECT 
    CAST([order_id] AS NVARCHAR(50)),
    CAST([payment_sequential] AS INT),
    CAST([payment_type] AS NVARCHAR(30)),
    CAST([payment_installments] AS INT),
    CAST([payment_value] AS DECIMAL(10, 2))
FROM CleanData
WHERE rowdata = 1;
GO


ALTER TABLE [feedback]
ADD CONSTRAINT FK_Feedback_Orders 
FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id]);
GO

ALTER TABLE [Orders]
ADD CONSTRAINT FK_Orders_Users 
FOREIGN KEY ([user_name]) REFERENCES [Users]([user_name]);
GO

ALTER TABLE [Order_Items]
ADD CONSTRAINT FK_OrderItems_Orders 
FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id]);
GO

ALTER TABLE [Order_Items]
ADD CONSTRAINT FK_OrderItems_Products 
FOREIGN KEY ([product_id]) REFERENCES [Products]([product_id]);
GO

ALTER TABLE [Order_Items]
ADD CONSTRAINT FK_OrderItems_Sellers 
FOREIGN KEY ([seller_id]) REFERENCES [Sellers]([seller_id]);
GO

ALTER TABLE [Order_Payments]
ADD CONSTRAINT FK_OrderPayments_Orders 
FOREIGN KEY ([order_id]) REFERENCES [Orders]([order_id]);
GO
