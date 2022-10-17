/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject3].[dbo].[NashvilleHousing]





  /*
Cleaning Data in SQL Queries
*/


Select *
From [PortfolioProject3].[dbo].[NashvilleHousing]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate)
FROM [PortfolioProject3].[dbo].[NashvilleHousing]

Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
Add SaleDateConverted Date;



Select saleDateConverted, CONVERT(Date,SaleDate)
FROM [PortfolioProject3].[dbo].[NashvilleHousing]


Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data



Select *
From [PortfolioProject3].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [PortfolioProject3].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject3].[dbo].[NashvilleHousing] b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b. [UniqueID]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [PortfolioProject3].[dbo].[NashvilleHousing] a
JOIN [PortfolioProject3].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City)



Select PropertyAddress
From [PortfolioProject3].[dbo].[NashvilleHousing]
--Where PropertyAddress is null
--order by ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
From [PortfolioProject3].[dbo].[NashvilleHousing]


ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
Add PropertySplitAddress Nvarchar(255);

Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
Add PropertySplitCity Nvarchar(255);

Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
From [PortfolioProject3].[dbo].[NashvilleHousing]



Select OwnerAddress
From [PortfolioProject3].[dbo].[NashvilleHousing]


--PARSENAME looks for periods. Add (REPLACE(OwnerAddress, ',', '.') to look for comma.
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3) as Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2) as City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) as State
From [PortfolioProject3].[dbo].[NashvilleHousing]



ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
Add OwnerSplitAddress Nvarchar(255);

Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
Add OwnerSplitCity Nvarchar(255);

Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
Add OwnerSplitState Nvarchar(255);

Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [PortfolioProject3].[dbo].[NashvilleHousing]




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PortfolioProject3].[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [PortfolioProject3].[dbo].[NashvilleHousing]


Update [PortfolioProject3].[dbo].[NashvilleHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
	   		 	  

-----------------------------------------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [PortfolioProject3].[dbo].[NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [PortfolioProject3].[dbo].[NashvilleHousing]


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From [PortfolioProject3].[dbo].[NashvilleHousing]


ALTER TABLE [PortfolioProject3].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
