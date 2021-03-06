#  Tests for the neotoma package.  Mostly validating that changes to the functions
#  do not break the requirements for data formatting.

require(testthat)
require(neotoma)

context('get_contact work as expected')

test_that('get_contact accepts and returns the right data types', 
          {
            expect_error(get_contact(contactid='aaa'))
            expect_error(get_contact(contactname=12))
            expect_error(get_contact(contactstatus=1))
            expect_error(get_contact(familyname=12))
            expect_message(get_contact(contactid=1), 'The API call')
            expect_message(get_contact(familyname='Smith'), 'The API call')
            expect_message(get_contact(contactname='*Smith*'), 'The API call')
          })

#-----------------------------------------------------

context('get_downloads works as expected')

test_that('get_download accepts numeric values and returns values as expected',
          {
            expect_error(get_download('a'))
            expect_error(get_download(factor('a')))
            expect_error(get_download(c('a', 'b')))
            expect_message(get_download(1), 'API call was successful')
            expect_that(length(get_download(1)) == 6, is_true())
            expect_that(length(get_download(c(1,2))) == 2, is_true())
            expect_is(get_download(1, verbose=FALSE), 'list')
          })


#-----------------------------------------------------

context('get_dataset works as expected')

test_that('is get_dataset working?', 
          {
            expect_error(get_dataset(siteid='a'))
            expect_error(get_dataset(datasettype=10))
            expect_error(get_dataset(datasettype='banana'))
            expect_error(get_dataset(piid='a'))
            expect_error(get_dataset(altmin='low'))
            expect_error(get_dataset(altmax='low'))
            expect_error(get_dataset(loc=10))
            expect_error(get_dataset(loc=c('a', 'b', 'c')))
            expect_error(get_dataset(gpid=10))
            expect_error(get_dataset(taxonids='Pine'))
            expect_error(get_dataset(taxonname=10))
            expect_error(get_dataset(ageold='min'))
            expect_error(get_dataset(ageyoung='max'))
            expect_error(get_dataset(ageof=10))
            expect_error(get_dataset(ageof='taxon'))
            expect_error(get_dataset(subdate=10))
            expect_is(get_dataset(siteid=1), 'dataset')
})

#-----------------------------------------------------

context('Crossing sites, datasets and downloads, using the API:')
test_that('Crossing APIs',
{
  expect_is(get_dataset(get_download(100)), 'dataset')
  expect_is(get_site(get_download(100)), 'data.frame')
  expect_is(get_site(get_dataset(siteid=100)), 'data.frame')
  expect_is(get_download(get_dataset(siteid=100)), 'download')
})
#-----------------------------------------------------

context('Compiling objects and returning what is expected:')
test_that('Compiling',
{
  expect_is(compile_downloads(get_download(100:103)), 'data.frame')
  expect_is(compile_taxa(get_download(100)), 'download')
})
