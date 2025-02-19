## BiomaRt
require(biomaRt)
require(tidyverse)

#' Get Gene Lookup Table from Ensembl Biomart
#' 
#' This function retrieves a gene lookup table from Ensembl's Biomart database for 
#' either the hg38 or hg19 genome builds. The lookup table contains key gene 
#' information, such as gene symbols, Ensembl IDs, chromosome locations, and biotypes.
#'
#' @param genome_build A string indicating the genome build to use. Options are:
#'   'hg38' (default) for the human genome build 38 or 'hg19' for build 19.
#' 
#' @return A tibble containing gene information from the selected genome build, including:
#'   - Chromosome name
#'   - Start and end positions
#'   - Gene biotype
#'   - HGNC symbol and ID
#'   - Entrez gene ID
#'   - Ensembl gene ID
#'   - Strand
#'   - External gene name (for hg38) or transcript information (for hg19).
#'
#' @examples
#' # Get gene lookup table for hg38
#' hg38_lookup <- get_biomart_gene_lookup('hg38')
#'
#' # Get gene lookup table for hg19
#' hg19_lookup <- get_biomart_gene_lookup('hg19')
#'
#' @export
get_biomart_gene_lookup <- function(genome_build = 'hg38') {
  
  if (genome_build == 'hg38') {
    
    # Get hg38 gene lookup table
    mart_hg38 <- useMart(biomart="ensembl", dataset="hsapiens_gene_ensembl")
    
    attribs <- as_tibble(listAttributes(mart_hg38))
    
    annot_lookup <- as_tibble(
      getBM(
        mart = mart_hg38,
        attributes = c(
          'chromosome_name', 
          'start_position', 
          'end_position',       
          'gene_biotype', 
          'hgnc_symbol',
          'hgnc_id',
          'entrezgene_id', 
          'ensembl_gene_id',
          'strand',
          'external_gene_name'),
        uniqueRows = TRUE))
    
  }
  
  if (genome_build == 'hg19') {
    
    mart_hg19 <- useMart(biomart="ensembl", host = 'https://grch37.ensembl.org')
    mart_hg19 <- useDataset('hsapiens_gene_ensembl', mart_hg19)
    
    annot_lookup <- as_tibble(
      getBM(
        mart = mart_hg19,
        attributes = c(
          'chromosome_name', 
          'description',
          'start_position', 
          'end_position',       
          'gene_biotype', 
          'hgnc_symbol',
          'entrezgene_id', 
          'ensembl_gene_id',
          'strand',
          'transcript_gencode_basic'),
        uniqueRows = TRUE))
    
  }
  
  return(annot_lookup)
  
}
