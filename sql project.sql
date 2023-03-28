select *
from portfolio.dbo.Nashville_Housing;

-- converting the saledate format
alter table portfolio.dbo.Nashville_Housing
add SaledateConverted date;

update portfolio.dbo.Nashville_Housing
set SaledateConverted= convert(date, Nashville_Housing.SaleDate);

select Nashville_Housing.SaleDate, SaledateConverted
from portfolio.dbo.Nashville_Housing;


-- cleaning property address
select *
from portfolio.dbo.NashvilleHousing
order by ParcelID

select a.ParcelID, a.propertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)as new_propertyAddress
from portfolio.dbo.Nashville_Housing as a
join portfolio.dbo.Nashville_Housing as b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolio.dbo.Nashville_Housing a
join portfolio.dbo.Nashville_Housing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null;

select PropertyAddress
from portfolio.dbo.Nashville_Housing

select 
SUBSTRING(PropertyAddress,1, charindex(',', PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, len(propertyAddress)) as address

from portfolio.dbo.Nashville_Housing;

Alter table portfolio.dbo.Nashville_Housing
add propertysplitAddress nvarchar(255)

update portfolio.dbo.Nashville_Housing
set propertysplitAddress = SUBSTRING(PropertyAddress,1, charindex(',', PropertyAddress)-1)

Alter table portfolio.dbo.Nashville_Housing
add propertysplitcity nvarchar(255)

update portfolio.dbo.Nashville_Housing
set propertysplitcity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1, len(propertyAddress));

select propertysplitAddress, propertysplitcity
from portfolio.dbo.Nashville_Housing

-- cleaning owner address
select OwnerAddress
from portfolio.dbo.Nashville_Housing

select 
PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from portfolio.dbo.Nashville_Housing

Alter table portfolio.dbo.Nashville_Housing
add OwnersplitAddress nvarchar(255);

update portfolio.dbo.Nashville_Housing
set OwnersplitAddress =PARSENAME(replace(OwnerAddress,',','.'),3);

Alter table portfolio.dbo.Nashville_Housing
add Ownersplitcity nvarchar(255)

update portfolio.dbo.Nashville_Housing
set Ownersplitcity = PARSENAME(replace(OwnerAddress,',','.'),2)

Alter table portfolio.dbo.Nashville_Housing
add Ownersplitstate nvarchar(255)

update portfolio.dbo.Nashville_Housing
set Ownersplitstate =PARSENAME(replace(OwnerAddress,',','.'),1);

select ownerAddress, ownersplitAddress,Ownersplitcity,ownersplitstate
from portfolio.dbo.Nashville_Housing;

-- cleaning sold as vacant column
select distinct(soldasvacant), count(soldasvacant)
from portfolio.dbo.Nashville_Housing
group by SoldAsVacant order by 2 desc;

-- using case statement
select soldasvacant,
case
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end as soldasvacant
from portfolio.dbo.Nashville_Housing

update portfolio.dbo.Nashville_Housing
set SoldAsVacant= case
when soldasvacant = 'Y' then 'Yes'
when soldasvacant = 'N' then 'No'
else soldasvacant
end 
from portfolio.dbo.Nashville_Housing;

select distinct(SoldAsVacant)
from portfolio.dbo.Nashville_Housing;

-- remove duplicate
with row_num as (
select*,
ROW_NUMBER() over(
partition by parcelID,propertyAddress, Saleprice, SaledateConverted,legalreference 
order by uniqueID) as RowNum
from portfolio.dbo.Nashville_Housing
)
select *
from row_num
where RowNum > 1;

select*
from portfolio.dbo.Nashville_Housing;
