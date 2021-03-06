% Generated by roxygen2 (4.0.1): do not edit by hand
\name{get_taxa}
\alias{get_taxa}
\title{Get taxon information from Neotoma.}
\usage{
get_taxa(taxonid, taxonname, status, taxagroup, ecolgroup)
}
\arguments{
\item{taxonid}{Numeric taxon identifier used in Neotoma}

\item{taxonname}{A character string representing the full or partial name of taxa of interest.}

\item{status}{The current status of the taxon, one of 'extinct', 'extant', 'all'.}

\item{taxagroup}{The taxonomic grouping for the taxa. See \url{http://api.neotomadb.org/doc/resources/taxa} for the list of approved groupings.}

\item{ecolgroup}{The ecological group of the taxa. More detailed than \code{taxagroup}, can be obtained using \code{get_table("EcolGroupTypes")}.}
}
\value{
Returns a table.

\describe{
\tabular{rll}{
 \tab \code{TaxonID}\tab Unique database record identifier for a taxon.\cr
 \tab \code{TaxonCode}\tab Shorthand notation for a taxon identification.\cr
 \tab \code{TaxonName}\tab Name of the taxon.\cr
 \tab \code{Author}\tab Author(s) of the name. Used almost exclusively with beetle taxa.\cr
 \tab \code{Extinct}\tab True if extinct; false if extant.\cr
 \tab \code{TaxaGroup}\tab Code for taxa group to which taxon belongs.\cr
 \tab \code{EcolGroups}\tab Array of ecological group codes to which the taxon belongs.\cr
 \tab \code{HigherTaxonID}\tab TaxonID of the next higher taxonomic rank.\cr
 \tab \code{PublicationID}\tab Publication identification number.\cr
 \tab \code{Notes}\tab Free-form notes or comments about the taxon.\cr
}
}
}
\description{
Get taxon information from Neotoma.
}
\examples{
\dontrun{
## Return all species taxa with "Abies" in name - note wildcard
taxa <- get_taxa(taxonname = "Abies*")
}
}
\author{
Simon J. Goring \email{simon.j.goring@gmail.com}
}
\references{
Neotoma Project Website: http://www.neotomadb.org
API Reference:  http://api.neotomadb.org/doc/resources/contacts
}
\keyword{API}
\keyword{Neotoma}
\keyword{Palaeoecology}

