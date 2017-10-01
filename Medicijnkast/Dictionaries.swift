//
//  Dictionaries.swift
//  MedCabinetFree
//
//  Created by Pieter Stragier on 22/03/17.
//  Copyright © 2017 PWS. All rights reserved.
//

import Foundation
let hyrdict0:Dictionary<String,String> = ["A": "Système cardio-vasculaire", "B": "Sang et coagulation", "C": "Système gastro-intestinal", "D": "Système respiratoire", "E": "Système hormonal", "F": "Gynéco-obstétrique", "G": "Système urogénital", "H": "Douleur et fièvre", "I": "Pathologies ostéo-articulaires", "J": "Système nerveux", "K": "Infections", "L": "Immunité", "M": "Médicaments antitumoraux", "N": "Minéraux, vitamines et toniques", "O": "Dermatologie", "P": "Ophtalmologie", "Q": "Oto-Rhino-Laryngologie", "R": "Anesthésie", "S": "Agents de diagnostic", "T": "Médicaments divers"]
    //["A":"Cardiovasculair stelsel", "B":"Bloed en stolling", "C":"Gastro-intestinaal stelsel", "D":"Ademhalingsstelsel", "E":"Hormonaal stelsel", "F":"Gynaeco-obstetrie", "G":"Urogenitaal stelsel", "H":"Pijn en koorts", "I":"Osteo-articulaire aandoeningen", "J":"Zenuwstelsel", "K":"Infecties", "L":"Immuniteit", "M":"Antitumorale middelen", "N":"Mineralen en vitaminen", "O":"Dermatologie", "P": "Oftalmologie", "Q":"Neus-Keel-Oren", "R":"Anesthesie", "S":"Diagnostica", "T":"Diverse geneesmiddelen"]
let hyrdict1:Dictionary<String,String> = ["AA":"Hypertension", "AB":"Angine de poitrine", "AC":"Insuffisance cardiaque", "AD":"Diurétiques", "AE":"Bêta-bloquants", "AF":"Antagonistes du calcium", "AG":"Médicaments agissant sur le système rénine-angiotensine", "AH":"Antiarythmiques ", "AI":"Hypotensions", "AJ":"Troubles vasculaires artériels", "AK":"Veinotropes et capillarotropes", "AL":"Hypolipidémiants", "AM":"Médicaments del'hypertension pulmonaire", "AN":"Alprostadil", "AO":"Médicaments pour stimuler la fermeture du canal artériel", "AP":"Associations pour la prévention cardio-vasculaire", "BA":"Antithrombotiques", "BB":"Antihémorragiques", "BC":"Médicaments de l'hématopoïèse", "CA":"Pathologie gastrique et duodénale", "CB":"Spasmolytiques", "CC":"Pathologie du foie, de la vésicule biliaire et du pancréas", "CD":"Antiémétiques", "CE":"Laxatifs", "CF":"Antidiarrhéiques", "CG":"Affections inflammatoires de l'intestin", "CH":"Pathologie anale", "DA":"Asthme et BPCO", "DB":"Antitussifs, mucolytiques et expectorants", "DC":"Médicaments divers dans des pathologies respiratoires", "EA":"Diabète", "EB":"Pathologie de la thyroïde", "EC":"Hormones sexuelles", "ED":"Corticostéroïdes", "EE":"Hormones hypophysaires et hypothalamiques", "EF":"Médicaments divers du système hormonal", "FA":"Médicaments dans les affections vulvovaginales", "FB":"Contraception", "FC":"Ménopause et substitution hormonale", "FD":"Médicaments agissant sur la motilité utérine", "FE":"Médicaments utilisés dans le cadre de la procréation assistée", "FF":"Progestatifs", "FG":"Antiprogestatifs", "FH":"Suppression de la lactation et hyperprolactinémie", "FI":"Médicaments divers utilisés en gynéco-obstétrique", "GA":"Troubles de la fonction vésicale", "GB":"Hypertrophie bénigne de la prostate", "GC":"Impuissance", "GD": "Médicaments divers dans les problèmes urogénitaux", "HA":"Approche médicamenteuse de la fièvre et de la douleur", "HB":"Analgésiques - Antipyrétiques", "HC":"Opioïdes", "HD":"Antagonistes opioïdes", "IA":"Anti-inflammatoires non stéroïiens", "IB":"Arthrite chronique", "IC":"Goutte", "ID":"Arthrose", "IE":"Ostéoporose et maladie de Paget", "IF":"Substances diverses utilisées dans des pathologies ostéo-articulaires", "JA":"Hypnotiques, sédatifs, anxiolytiques", "JB":"Antipsychotiques", "JC":"Antidépresseurs", "JD":"Médicaments de l'ADHD et de la narcolepsie", "JE":"Médicaments utilisés dans le cadre de la dépendance", "JF":"Antiparkinsoniens", "JG":"Antiépileptiques", "JH":"Médicaments des états spastiques", "JI":"Antimigraineux", "JJ":"Inhibiteurs des cholinestérases", "JK":"Médicaments de la maladie d'Alzheimer", "JL":"Médicaments de la maladie de Huntington", "JM":"Médicaments de la sclérose latérale amyotrophique (SLA)", "JN":"Médicaments de la sclérose en plaques (SEP)", "KA":"Antibactériens", "KB":"Antimycosiques", "KC":"Antiparasitaires", "KD":"Antiviraux", "LA":"Vaccins", "LB":"Immunoglobulines", "LC":"Immunomodulateurs", "LD":"Allergie", "MA":"Agents alkylants", "MB":"Antimétabolites", "MC":"Antibiotiques antitumoraux", "MD":"Inhibiteurs de la topo-isomérase", "ME":"Inhibiteurs des microtubules", "MF":"Anticorps monoclonaux et cytokines", "MG":"Inhibiteurs de protéines kinases", "MH":"Antitumoraux divers", "MI":"Médicaments hormonaux utilisés on oncologie", "MJ":"Médicaments contre les effets indésirables des antitumoraux", "NA":"Minéraux", "NB":"Vitamines", "OA":"Médicaments anti-infectieux", "OB":"Corticostéroïdes", "OC":"Antiprurigineux", "OD":"Médicaments des traumatismes et des affections veineuses", "OE":"Acné", "OF":"Rosacée", "OG":"Psoriasis", "OH":"Kératolytiques", "OI":"Enzymes", "OJ":"Préparations protectrices", "OK":"Immunomodulateurs", "OL":"Médicaments divers à usage dermatologique", "OM":"Pansements actifs", "PA":"Anti-infectieux", "PB":"Antiallergiques et anti-inflammatoires", "PC":"Décongestionnants", "PD":"Mydriatiques - Cycloplégiques", "PE":"Médicaments du glaucome", "PF":"Anesthésiques locaux", "PG":"Larmes artificielles", "PH":"Agents de diagnostic en ophtalmologie", "PI":"Médicaments utilisés en chirurgie oculaires", "PJ":"Médicaments utilisés dans la dégénérescence maculaire", "PK":"Médicaments de la traction vitréo-maculaire", "QA":"Médicaments à usage otique", "QB":"Maladie de Ménière", "QC":"Rhinite et sinusite", "QD":"Affections oro-pharyngées", "RA":"Anesthésie générale", "RB":"Anesthésie locale", "SA":"Agents de radiodiagnostic", "SB":"Agents de diagnostic par résonance magnétique", "SC":"Tuberculine", "SD":"Agents de diagnostic divers", "TA":"Antidotes et chélateurs", "TB":"Obésité", "TC":"Maladies métaboliques congénitales", "TD":"Médicaments homéopathiques"]
    //["AA":"Hypertensie", "AB":"Angina pectoris", "AC":"Hartfalen", "AD":"Diuretica", "AE":"Bèta-blokkers", "AF":"Calciumantagonisten", "AG":"Middelen inwerkend op het renine-angiotensinesysteem", "AH":"Antiaritmica", "AI":"Hypotensie", "AJ":"Arteriële vaatstoornissen", "AK":"Veno- en capillarotropica", "AL":"Hypolipemiërende middelen", "AM":"Middelen bij pulmonale hypertensie", "AN":"Alprostadil", "AO":"Middelen i.v.m. het sluiten van de ductus arteriosus", "AP":"Associaties voor cardiovasculaire preventie", "BA":"Antitrombotica", "BB":"Antihemorragica", "BC":"Middelen i.v.m. de bloedvorming", "CA":"Maag- en duodenumpathologie", "CB":"Spasmolytica", "CC":"Lever-, galblaas- en pancreaspathologie", "CD":"Anti-emetica", "CE":"Laxativa", "CF":"Antidiarreïca", "CG":"Inflammatoir darmlijden", "CH":"Anale pathologie", "DA":"Astma en COPD", "DB":"Antitussiva, mucolytica en expectorantia", "DC":"Diverse geneesmiddelen bij respiratoire aandoeningen", "EA":"Diabetes", "EB":"Schildklierpathologie", "EC":"Geslachtshormonen", "ED":"Corticosteroïden", "EE":"Hypofysaire en hypothalame hormonen", "EF":"Diverse middelen i.v.m. het hormonale stelsel", "FA":"Middelen bij vulvovaginale aandoeningen", "FB":"Anticonceptie", "FC":"Menopauze en hormonale substitutie", "FD":"Middelen i.v.m. de uterusmotiliteit", "FE":"Middelen in het kader van geassisteerde vruchtbaarheid", "FF":"Progestagenen", "FG":"Antiprogestagenen", "FH":"Lactatieremming en hyperprolactinemie", "FI":"Diverse middelen gebruikt in de gynaeco-obstetrie", "GA":"Blaasfunctiestoornissen", "GB":"Benigne prostaathypertrofie", "GC":"Impotentie", "GD": "Diverse middelen bij uro-genitale problemen", "HA":"Medicamenteuze koorts- en pijnbestrijding", "HB":"Analgetica - Antipyretica", "HC":"Opioïden", "HD":"Opioïdantagonisten", "IA":"Niet-steroïdale anti-inflammatoire middelen", "IB":"Chronische artritis", "IC":"Jicht", "ID":"Artrose", "IE":"Osteoporose en ziekte van Paget", "IF":"Diverse middelen bij osteo-articulaire aandoeningen", "JA":"Hypnotica, sedativa, anxiolytica", "JB":"Antipsychotica", "JC":"Antidepressiva", "JD":"Middelen bij ADHD en narcolepsie", "JE":"Middelen i.v.m. afhankelijkheid", "JF":"Antiparkinsonmiddelen", "JG":"Anti-epileptica", "JH":"Middelen bij spasticiteit", "JI":"Antimigrainemiddelen", "JJ":"Cholinesterase-inhibitoren", "JK":"Anti-Alzheimermiddelen", "JL":"Middelen bij de ziekte van Huntington", "JM":"Middelen bij amyotrofe laterale sclerose (ALS)", "JN":"Middelen bij multiple sclerose (MS)", "KA":"Antibacteriële middelen", "KB":"Antimycotica", "KC":"Antiparasitaire middelen", "KD":"Antivirale middelen", "LA":"Vaccins", "LB":"Immunoglobulinen", "LC":"Immunomodulatoren", "LD":"Allergie", "MA":"Alkylerende middelen", "MB":"Antimetabolieten", "MC":"Antitumorale antibiotica", "MD":"Topo-isomerase-inhibitoren", "ME":"Microtubulaire inhibitoren", "MF":"Monoklonale antilichamen en cytokines", "MG":"Proteïnekinase-inhibitoren", "MH":"Diverse antitumorale middelen", "MI":"Hormonale middelen in de oncologie", "MJ":"Middelen bij ongewenste effecten van antitumorale middelen", "NA":"Mineralen", "NB":"Vitaminen", "OA":"Anti-infectieuze middelen", "OB":"Corticosteroïden", "OC":"Middelen tegen jeuk", "OD":"Middelen bij traumata en veneuze aandoeningen", "OE":"Acne", "OF":"Rosacea", "OG":"Psoriasis", "OH":"Keratolytica", "OI":"Enzymen", "OJ":"Beschermende middelen", "OK":"Immunomodulatoren", "OL":"Diverse dermatologische middelen", "OM":"Actieve verbandmiddelen", "PA":"Anti-infectieuze middelen", "PB":"Anti-allergische en anti-inflammatoire middelen", "PC":"Decongestionerende middelen", "PD":"Mydriatica - Cycloplegica", "PE":"Antiglaucoommiddelen", "PF":"Lokale anesthetica", "PG":"Kunsttranen", "PH":"Diagnostica in de oftalmologie", "PI":"Middelen bij oogchirurgie", "PJ":"Middelen bij maculadegeneratie", "PK":"Middelen bij vitreomaculaire tractie", "QA":"Middelen voor gebruik in het oor", "QB":"Ziekte van Ménière", "QC":"Rhinitis en sinusitis", "QD":"Orofaryngeale aandoeningen", "RA":"Algemene anesthesie", "RB":"Lokale anesthesie", "SA":"Radiodiagnostica", "SB":"Diagnostica voor magnetische resonantie", "SC":"Tuberculine", "SD":"Diverse diagnostica", "TA":"Antidota en chelatoren", "TB":"Obesitas", "TC":"Aangeboren metabole aandoeningen", "TD":"Homeopathische middelen"]
class Dictionaries {
    func hierarchy(hyr:String) -> String {
        var hyrstring:String = ""
        let firstCharacter = hyr[hyr.index(hyr.startIndex, offsetBy: 0)]
        let start = hyr.index(hyr.startIndex, offsetBy: 0)
        let end = hyr.index(hyr.startIndex, offsetBy: 1)
        let range = start...end
        let firstTwoCharacters = hyr[range]
        
        if hyr.characters.count == 1 {
            hyrstring = (hyrdict0[String(firstCharacter)])!
        } else {
            hyrstring = (hyrdict0[String(firstCharacter)])! + " > " + (hyrdict1[String(firstTwoCharacters)])!
        }
        return hyrstring
    }
    
    func wada(wada:String) -> String {
        var wadastring:String = ""
        let wadadict: Dictionary<String,String> = ["A": "Anabolisants, interdits en toutes circonstances", "B": "Bêta-bloquants, interdits en competition pour certains sports de concentration et interdit en toutes circonstances pour le tir et le tir à l'arc.", "B2": "Tous les Bêta2-mimétiques sont interdits sauf le salbutamol, le salmétérol et le formotérol administrés par inhalation conformément au schéma trérapeutique recommandé.", "C": "Corticostéroïdes, interdits en compétition sauf en usage nasal, dermatologique ou par inhalation.", "c": "Attention: Corticostéroïdes (nasal, dermatologique, inhalation). Pas d'AUT (autorisation pour usage thérapeutique) exigée mais utilisation à signaler au médecin-contrôle.", "D": "Diurétiques, interdits en toutes circonstances", "d": "Attention: Peut entraîner un controôle antidopage positif pour la morphine. Le sportif doit avertir le médecin-contrôle lors d'un contrôle antidopage éventuel", "DB": "Contient des diurétiques, interdits en toutes circonstances.", "Hman": "Interdit en toutes circonstances pour des athlètes masculins.", "H": "Interdit en toutes circonstances.", "M": "Agents masquants, interdits en toutes circonstances.", "N": "Narcotiques, interdits en compétition.", "O": "Anti-estrogènes, interdits en toutes circonstances.", "AO": "Anti-estrogènes, interdits en toutes circonstances", "P": "Attention. Peut conduire à une perturbation des résultats d'analyse pour la cathine. Le sportif doit avertir le médecin-contrôle lors d'un contrôle antidopage éventuel.", "S": "Stimulants, interdits en compétition.", "s": "Attention. Contient des stimulants, ce qui peut conduire à une perturbation des résultats d'analyse. Le sportif doit avertir le médicin-contrôle lors d'un contrôle antidopage."]
        
        wadastring = wadadict[wada]!
        return wadastring
    }
    
    func ssecr(ssecr:String) -> String {
        let ssecrLijst = ssecr.components(separatedBy: " ")
        var ssecrstringLijst: Array<String> = []
        var ssecrstring:String = ""
        let ssecrdict: Dictionary<String,String> = ["a":"catégorie a", "b":"catégorie b", "c":"catégorie c", "cx":"catégorie cx", "cs":"catégorie cs", "b2":"b2: a priori contrôle", "c2":"c2: a priori contrôle", "a4":"a4: a posteriori contrôle", "b4":"b4: a posteriori contrôle", "c4":"c4: a posteriori contrôle", "s4":"s4: a posteriori contrôle", "h": "h: remboursement unique en usage hospitalier", "J":"J: allocation spéciale par l'INAMI pour les femmes < 21j.", "aJ":"aJ: gratuit pour les femmes < 21j.", "Chr":"Chr: allocation spéciale par l'INAMI pour la douleur chronique.", "_":"aucun", "":"aucun"]
        for part in ssecrLijst {
            ssecrstringLijst.append(ssecrdict[part]!)
        }
        ssecrstring = ssecrstringLijst.joined(separator: ", ")
        
        return ssecrstring
    }
    
    func level0Picker() -> Dictionary<String,String> {
        return hyrdict0
    }
    
    func level1Picker() -> Dictionary<String,String> {
        return hyrdict1
    }
}
