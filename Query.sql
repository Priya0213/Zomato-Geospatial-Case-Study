INSERT INTO Restaurants (
    RestaurantID, 
    Name, 
    Location, 
    AverageCostForTwo, 
    AggregateRating, 
    Votes, 
    ServiceType,
    OnlineOrder,
    BookTable,
    Cuisines
)
SELECT 
    CAST(restaurant_id AS INT),
    restaurant_name,
    location,
    TRY_CAST(cost_for_two_clean AS FLOAT),
    TRY_CAST(rating_clean AS FLOAT),
    TRY_CAST(votes AS INT),
    service_type,
    online_order,
    book_table,
    cuisines
FROM ZomatoRaw;


SELECT TOP 10 * FROM Restaurants;


SELECT COUNT(*) AS TotalRows FROM Restaurants;


SELECT MIN(AverageCostForTwo), MAX(AverageCostForTwo) FROM Restaurants;


SELECT MIN(AggregateRating), MAX(AggregateRating) FROM Restaurants;




select * from Restaurants


SELECT Name, Location, COUNT(*) AS NumDupes FROM Restaurants
GROUP BY Name, Location
HAVING COUNT(*) > 1
ORDER BY NumDupes DESC;

WITH CTE AS (
        SELECT RestaurantID, Name, Location,
        ROW_NUMBER() OVER (PARTITION BY Name, Location
        ORDER BY RestaurantID) AS rn
        FROM Restaurants
)
DELETE FROM Restaurants
WHERE RestaurantID IN (
        SELECT RestaurantID FROM CTE WHERE rn > 1);

-- converting coordinates into geospatial objects
ALTER TABLE [dbo].[Restaurants] 
ADD GeoLocation_Geography geography;



-- Add Latitude column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Latitude' AND Object_ID = Object_ID(N'[dbo].[Restaurants]'))
BEGIN
    ALTER TABLE [dbo].[Restaurants]
    ADD Latitude float; -- Or decimal, depending on your precision needs
END

-- Add Longitude column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE Name = N'Longitude' AND Object_ID = Object_ID(N'[dbo].[Restaurants]'))
BEGIN
    ALTER TABLE [dbo].[Restaurants]
    ADD Longitude float; -- Or decimal
END



EXEC sp_columns Restaurants;


-- First, check if the column exists and drop it if it does
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Restaurants]') AND name = N'GeoLocation_Geography')
BEGIN
    ALTER TABLE [dbo].[Restaurants] DROP COLUMN GeoLocation_Geography;
END

-- Then, add the column with the correct data type
ALTER TABLE Restaurants
ADD GeoLocation_Geography GEOGRAPHY;



select * from [dbo].[Restaurants]



UPDATE Restaurants
SET GeoLocation_Geography = geography::Point(Latitude, Longitude, 4326)
WHERE Latitude IS NOT NULL AND Longitude IS NOT NULL;
UPDATE Restaurants
SET GeoLocation_Geography = geography::Point(Latitude, Longitude, 4326)
WHERE Latitude IS NOT NULL AND Longitude IS NOT NULL;
GO


UPDATE r
SET r.Latitude = l.latitude,
    r.Longitude = l.longitude,
    r.GeoLocation = geography::Point(l.latitude, l.longitude, 4326)
FROM Restaurants r
JOIN Locations l
  ON r.location = l.location;

  select * from Restaurants
  select * from [dbo].[locations]

