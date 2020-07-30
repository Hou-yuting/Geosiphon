#Created by J.Keller (University of Toulouse III)
import pandas as pds


def parse_orthofinder_species(df, smand, sabs):
    """
    Function to filter OrthoFinder output
    :param df: dataframe of orthogroups
    :param smand: list of species that have to be present in the orthogroups
    :param sabs: list of species that have to be absent from the orthogroups
    :return: dataframe of orthogroups containing mandatory present species and no mandatory absent species
    """
    for i in smand:
        df = df.loc[df[i].notnull()]
    if len(sabs) != 0:
        for j in sabs:
            df = df.loc[df[j].isnull()]
    return df


# load orthogroups
dfOrthogroups = pds.read_csv(r"Orthogroups.tsv", dtype=str, sep="\t")

# orthogroups putatively gain by AMF (rules: present in G. pyriformis, present in R. irregularis or R. cerebriforme and
# in D. versiformis or G. rosea, absent in all four non AMF)
amfGainOgPresentSpecies = ["Geopyr_geosiphon_protein"]

amfGainOgAbsentSpecies = ["Morelo_Morel2_GeneCatalog_proteins_20151120.aa", "Muccir_Mucci2_Filtered_proteins",
                          "Rhimic_Rhimi_ATCC52814_1_GeneCatalog_proteins_20150309.aa", "Phybla_Phybl2_proteins"]

dfGeopyr = parse_orthofinder_species(dfOrthogroups, amfGainOgPresentSpecies, amfGainOgAbsentSpecies)

dfGainOg = dfGeopyr[(dfGeopyr["Divver_diversispora_protein"].notnull() |
                     dfGeopyr["Gigros_Gigro1_GeneCatalog_proteins_20160405.aa"].notnull())
                    & (dfGeopyr["Rhicer_Rhice1_1_GeneCatalog_proteins_20160727.aa"].notnull() |
                       dfGeopyr["Rhiirr_Rhiir2_1_GeneCatalog_proteins_20160502.aa"].notnull())]

pds.DataFrame.to_csv(dfGainOg, "putative_gain_og_amf.txt", sep="\t", index=False, line_terminator="\n")

# orthogroups putatively lost by AMF (rules: present in all non AMF fungi, absent in all AMF fungi)
amfLostOgPresentSpecies = amfGainOgAbsentSpecies
amfLostOgAbsentSpecies = ["Geopyr_geosiphon_protein", "Divver_diversispora_protein",
                          "Rhicer_Rhice1_1_GeneCatalog_proteins_20160727.aa",
                          "Rhiirr_Rhiir2_1_GeneCatalog_proteins_20160502.aa",
                          "Gigros_Gigro1_GeneCatalog_proteins_20160405.aa"]
dfLostOg = parse_orthofinder_species(dfOrthogroups, amfLostOgPresentSpecies, amfLostOgAbsentSpecies)

pds.DataFrame.to_csv(dfLostOg, "putative_lost_og_amf.txt", sep="\t", index=False, line_terminator="\n")
