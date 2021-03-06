#' Function to return geochronological data from records.
#'
#' Using the dataset ID, return all geochronological data associated with the dataID.  At present,
#'    only returns the dataset in an unparsed format, not as a data table.   This function will only download one dataset at a time.
#'
#' @import RJSONIO RCurl
#' @param datasetid A single numeric dataset ID or a vector of numeric dataset IDs as returned by \code{get_datasets}.
#' @param verbose logical; should messages on API call be printed?
#' @author Simon J. Goring \email{simon.j.goring@@gmail.com}
#' @return This command returns either a 'try-error' definined by the error returned
#'    from the Neotoma API call, or geochronology table:
#'  
#' \itemize{
#'  \item{sample.id}{A unique identifier for the geochronological unit.}
#'  \item{age.type.id}{Numeric. One of five possible age types.}
#'  \item{age.type}{String.  The age type, one of calendar years, radiocarbon years, etc.}
#'  \item{age}{Dated age of the material.}
#'  \item{e.older}{The older error limit of the age value.  Commonly 1 standard deviation.}
#'  \item{e.young}{The younger error limit of the age value.}
#'  \item{delta13C}{The measured or assumed delta13C value for radiocarbon dates, if provided.}
#'  \item{material.dated}{A table describing the collection, including dataset information, PI data compatable with \code{get_contacts} and site data compatable with \code{get_sites}.}
#'  \item{geo.chron.type.id}{Numeric identification for the type of geochronological analysis.}
#'  \item{geo.chron.type}{Text string, type of geochronological analysis, i.e., Radiocarbon dating, luminesence.}
#'  \item{notes}{Text string}
#'  \item{infinite}{Boolean, does the dated material return an "infinte" date?}
#' }
#'
#'  A full data object containing all the relevant geochronological data available for a dataset.
#' @examples \dontrun{
#' #  Search for sites with "Pseudotsuga" pollen that are older than 8kyr BP and
#' #  find the relevant geochronological data associated with the samples.  Are some time periods better dated than others?
#' t8kyr.datasets <- get_dataset(taxonname='*Pseudotsuga*', loc=c(-150, 20, -100, 60), ageyoung = 8000)
#'
#' #  Returns 74 records (as of 01/08/2014), get the dataset IDs for all records:
#' dataset.ids <- sapply(t8kyr.datasets, function(x) x$DatasetID)
#' geochron.records <- sapply(dataset.ids, function(x)try(get_geochron(x)))
#'
#' #  Standardize the taxonomies for the different records using the WS64 taxonomy.
#' 
#' get_ages <- function(x){
#'   any.ages <- try(x$age[x$age.type.id == 4])
#'   if(class(any.ages) == 'try-error') output <- NA
#'   if(!class(any.ages) == 'try-error') output <- unlist(any.ages)
#'   output
#' }
#' 
#' radio_chron <- unlist(sapply(geochron.records, get_ages))
#' 
#' hist(radio_chron, breaks=seq(0, 40000, by = 500), 
#'      main = 'Distribution of radiocarbon dates for Pseudotsuga records',
#'      xlab = 'Radiocarbon date (14C years before 1950)')
#' }
#' 
#' @references
#' Neotoma Project Website: http://www.neotomadb.org
#' API Reference:  http://api.neotomadb.org/doc/resources/contacts
#' @keywords Neotoma Palaeoecology API
#' @export
#' 
get_geochron <- function(datasetid, verbose = TRUE){

    # Updated the processing here. There is no need to be fiddling with
    # call. Use missing() to check for presence of argument
    # and then process as per usual
    base.uri <- 'http://api.neotomadb.org/v1/apps/geochronologies/'

    if (missing(datasetid)) {
        stop(paste(sQuote("datasetid"), "must be provided."))
    } else {
        if (!is.numeric(datasetid))
            stop('datasetid must be numeric.')
    }

    # Get sample is a function because we can now get
    # one or more geochronologies at a time.
    get_sample <- function(x){
      # query Neotoma for data set
      aa <- try(fromJSON(paste0(base.uri, '?datasetid=', x), nullValue = NA))
  
      # Might as well check here for error and bail
      if (inherits(aa, "try-error"))
          return(aa)
  
      # if no error continue processing
      if (isTRUE(all.equal(aa[[1]], 0))) {
        # The API did not return a record, or returned an error.
          stop(paste('Server returned an error message:\n', aa[[2]]),
               call. = FALSE)
      }
  
      if (isTRUE(all.equal(aa[[1]], 1) & length(aa[[2]]) == 0)) {
        # The API returned a record, but the record did not
        # have associated geochronology information.
        stop('No geochronological record is associated with this sample',
             call. = FALSE)
      }
      
      if (isTRUE(all.equal(aa[[1]], 1) & length(aa[[2]]) > 0)) {
        # The API returned a record with geochron data.
        aa <- aa[[2]]
      
        if (verbose) {
            message(strwrap(paste0("API call was successful. ",
                                   "Returned record for",
                                     aa[[1]]$Site$SiteName)))
        }

        # If there are actual stratigraphic samples
        # with data in the dataset returned.

        ageid <- get_table("AgeTypes")
        geoid <- get_table("GeochronTypes")
        
        pull.rec <- function(x){
          
          age.type <- ageid$AgeType[match(x$AgeTypeID, ageid$AgeTypeID)]
          geo.chron.type <- geoid$GeochronType[match(x$GeochronTypeID,
                                                     geoid$GeochronTypeID)]
          
          data.frame(sample.id = x$SampleID,
                     geochron.id = x$GeochronID,
                   age.type.id = x$AgeTypeID,
                   age.type = age.type,
                   age = x$Age,
                   e.older = x$ErrorOlder,
                   e.young = x$ErrorYounger,
                   delta13C = x$Delta13C,
                   lab.no = x$LabNumber,
                   material.dated = x$MaterialDated,
                   geo.chron.type.id = x$GeochronTypeID,
                   geo.chron.type = geo.chron.type,
                   notes = x$Notes,
                   infinite = x$Infinite,
                   stringsAsFactors = FALSE)
        }
        
      out <- t(sapply(aa, pull.rec))
          
      }
      
      
      as.data.frame(out)
    }
    
    lapply(datasetid, try(get_sample))

}
