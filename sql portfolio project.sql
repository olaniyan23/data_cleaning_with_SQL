select*
from dbo.NashvilleHousing;

-- converting the saledate format
alter table dbo.NashvilleHousing
add SaledateConverted date;

update dbo.NashvilleHousing
set SaledateConverted= convert(date, SaleDate);

select SaleDate, SaledateConverted
from dbo.NashvilleHousing;

-- cleaning property address
select *
from dbo.NashvilleHousing
order by ParcelID

select a.ParcelID, a.propertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)as new_propertyAddress
from dbo.NashvilleHousing a
join dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.NashvilleHousing a
join dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

select PropertyAddress
from dbo.NashvilleHousing

select 
SUBSTRING(PropertyAddress,1, charindex(',', PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, len(propertyAddress)) as address

from dbo.NashvilleHousing;

Alter table dbo.NashvilleHousing
add propertysplitAddress nvarchar(255)

update dbo.NashvilleHousing
set propertysplitAddress = SUBSTRING(PropertyAddress,1, charindex(',', PropertyAddress)-1)

Alter table dbo.NashvilleHousing
add propertysplitcity nvarchar(255)

update dbo.NashvilleHousing
set propertysplitcity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, len(propertyAddress));

select propertysplitAddress, propertysplitcity
from dbo.NashvilleHousing

-- cleaning owner address
select OwnerAddress
from dbo.NashvilleHousing

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from dbo.NashvilleHousing

Alter table dbo.NashvilleHousing
add OwnersplitAddress nvarchar(255);

update dbo.NashvilleHousing
set OwnersplitAddress =PARSENAME(replace(OwnerAddress,',','.'),3);

Alter table dbo.NashvilleHousing
add Ownersplitcity nvarchar(255)

update dbo.NashvilleHousing
set Ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table dbo.NashvilleHousing
add Ownersplitstate nvarchar(255)

update dbo.NashvilleHousing
set Ownersplitstate =PARSENAME(replace(OwnerAddress,',','.'),1);

select ownerAddress, ownersplitAddress,Ownersplitcity,ownersplitstate
from dbo.NashvilleHousing;

-- cleaning sold as vacant column
select distinct(soldasvacant), count(soldasvacant)
from dbo.NashvilleHousing
group by SoldAsVacant order by 2 desc;

-- using case statement
select soldasvacant,
case
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end as soldasvacant
from dbo.NashvilleHousing

update dbo.NashvilleHousing
set SoldAsVacant= case
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 
from dbo.NashvilleHousing;

select distinct(SoldAsVacant)
from dbo.NashvilleHousing;

-- remove duplicate
with row_num as (
select*,
ROW_NUMBER() over(
partition by parcelID,propertyAddress, Saleprice, SaledateConverted,legalreference 
order by uniqueID) as RowNum
from dbo.NashvilleHousing
)
select *
from row_num
where RowNum > 1;


-- deleting unused columns

Alter table portfolio.dbo.NashvilleHousing
drop column OwnerAddress, PropertyAddress, TaxDistrict,SaleDate

select*
from dbo.NashvilleHousing