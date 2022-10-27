select SaleDateConverted
FROM [portfolio-project]..Nashville



/*Cleaning Nashville Housing Data in SQL Queries */

--1- 
-- Showing the whole table

SELECT *
FROM [portfolio-project]..Nashville

--2- 
-- Standrize the date fromat

ALTER TABLE [portfolio-project]..Nashville
ADD SaleDateConverted Date;

UPDATE [portfolio-project]..Nashville
SET SaleDateConverted = CONVERT(Date, SaleDate)


--3- 
-- Populate PropertyAddress Data

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [portfolio-project]..Nashville a
JOIN [portfolio-project]..Nashville b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


--4- 
-- Breaking address into individual columns

ALTER TABLE [portfolio-project]..Nashville
ADD Propertysplitaddress NVARCHAR(225);


ALTER TABLE [portfolio-project]..Nashville
ADD PropertyCity NVARCHAR(225)


UPDATE [portfolio-project]..Nashville
SET PropertysplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',',PropertyAddress)-1)

UPDATE [portfolio-project]..Nashville
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))





ALTER TABLE [portfolio-project]..Nashville
ADD OwnerSplitAddress NVARCHAR(225)

ALTER TABLE [portfolio-project]..Nashville
ADD OwnerCity NVARCHAR(225)

ALTER TABLE [portfolio-project]..Nashville
ADD OwnerState NVARCHAR(225)


UPDATE [portfolio-project]..Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(owneraddress, ',','.'),3)

UPDATE [portfolio-project]..Nashville
SET OwnerCity = PARSENAME(REPLACE(owneraddress,',','.'),2)

UPDATE [portfolio-project]..Nashville
SET OwnerState = PARSENAME(REPLACE(owneraddress,',','.'),1)




--6- Change Y and N to Yes and No


UPDATE [portfolio-project]..Nashville
SET SoldAsVacant = Case WHEN SoldAsVacant = 'Y' THEN 'YES'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
-------------------------------------------


--7- Remove Duplicates

WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER(
	PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	ORDER BY UniqueID) row_num

FROM [portfolio-project]..Nashville
)

DELETE
FROM RowNumCTE
WHERE row_num > 1

-----------------------------------------------

--8- Delete Unused Columns

ALTER TABLE [portfolio-project]..Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress









)






)



SELECT 
	

	FROM [portfolio-project]..Nashville




SELECT Distinct (soldasvacant)
FROM [portfolio-project]..Nashville

SELECT ownersplitaddress, ownercity, ownerstate
FROM [portfolio-project]..Nashville



SELECT OwnerAddress
FROM [portfolio-project]..Nashville














