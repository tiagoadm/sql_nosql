Create Function [dbo].[RemoveNonAlphaCharacters](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin
    Declare @KeepValues as varchar(50)
    Set @KeepValues = '%[^a-z]%'
    While PatIndex(@KeepValues, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@KeepValues, @Temp), 1, '')

    Return @Temp
End

UPDATE [Person].[EmailAddress] 
SET [EmailAddress] = SUBSTRING(CONVERT(varchar(40), NEWID()),0,9)+'@'+SUBSTRING(CONVERT(varchar(40), NEWID()),0,9)+'.com'

UPDATE [Person].[Password]
SET PasswordHash = CONVERT(varchar(40), NEWID())+CONVERT(varchar(40), NEWID())+CONVERT(varchar(40), NEWID())+SUBSTRING(CONVERT(varchar(40), NEWID()),0,8),
	PasswordSalt = SUBSTRING(CONVERT(varchar(40), NEWID()),0,10)

UPDATE [Person].[Person] 
SET [FirstName] = 'A'+lower(dbo.RemoveNonAlphaCharacters(SUBSTRING(CONVERT(varchar(40), NEWID()),0,15))),
MiddleName = 'A'+lower(dbo.RemoveNonAlphaCharacters(SUBSTRING(CONVERT(varchar(40), NEWID()),0,15))),
LastName = 'A'+lower(dbo.RemoveNonAlphaCharacters(SUBSTRING(CONVERT(varchar(40), NEWID()),0,15)))

UPDATE [Person].[PersonPhone] 
SET [PhoneNumber] = 123+'-'+123+'-'+123