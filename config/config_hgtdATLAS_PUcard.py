import util.post_processing.jets as jets
import util.particle_selection.particle_selection as parsel
import util.particle_selection.selection_algos as algos

config = {
    'generation': {
        'proc': 'Top_Wqq_ATLAS',
        'hadronization': True,
        'mpi': True,
        'isr': True,
        'fsr': True,
        'rng': 47,
        'verbose': False,
        'hepmc_format': 'root'
    },

    'pileup': {
        'handler': None,
    },

    'simulation': {
        'type': 'delphes',
        'delphes_card': "util/delphes/cards/delphes_card_HGTD_ATLAS.tcl",

        #   Track            ← TrackMerger/tracks         (tracce con TOF)
        #   TrackSmeared     ← TimeSmearing/tracks         (pre-TOF, per diagnostica)
        #   Tower            ← Calorimeter/towers
        #   ParticleFlowCandidate ← EFlowMerger/eflow     (EFlow completo)
        #   Electron, Photon, Muon, Jet, GenJet
        #   GenMissingET, MissingET, ScalarHT
        #   GenVertex        ← TruthVertexFinder/vertices  (vertice truth)
        #   PileUpVertices   ← PileUpMerger/vertices       (vertici pileup)
        'delphes_output': [
            'Track',                  # tracce cariche con timing HGTD
            'Tower',                  # tower calorimetriche (grezzo)
            'ParticleFlowCandidate',  # EFlow completo (tracce+fotoni+had. neutri)
            'Electron',
            'Muon',
            'Photon',
            'Jet',                    # include già BTag dalla card
            'GenJet',
            'GenMissingET',
            'MissingET',
            'GenVertex',              # vertice primario truth
            'PileUpVertices',         # vertici ricostruiti (IP / SV per b-tag)
        ],
        'delphes_rng_seed': 47
    },

    'reconstruction': {
        'n_stable': 200,
        'n_delphes': [
            200,   # Track
            500,   # Tower
            500,   # ParticleFlowCandidate
            50,    # Electron
            50,    # Muon
            50,    # Photon
            50,    # Jet
            50,    # GenJet
            1,     # GenMissingET
            1,     # MissingET
            5,     # GenVertex
            200,   # PileUpVertices (fino a ~200 con MeanPileUp=190)
        ],
        'fastjet_dir': None,
        'n_truth': 1 + 60,
        'event_filter': None,
        'event_filter_flag': None,

        'particle_selection': {
            'TruthBQuarks':
                parsel.MultiSelection([
                    parsel.FirstSelector(22,  5),
                    parsel.FirstSelector(22, -5),
                ]),
            'TruthBChildren':
                parsel.MultiSelection([
                    parsel.AlgoSelection(
                        algos.SelectFinalStateDaughters(
                            parsel.FirstSelector(22, 5)
                        ), n=120
                    ),
                    parsel.AlgoSelection(
                        algos.SelectFinalStateDaughters(
                            parsel.FirstSelector(22, -5)
                        ), n=120
                    ),
                ]),
        },

        'signal_flag': 1,
        'split_seed': 1,

        'post_processing': [

            # Jet R=0.4 su ParticleFlowCandidate (= EFlow completo dalla card)
            # Ghost-associated ai figli del b/b̄ → label per b-tagging
            jets.JetFinder(
                ['ParticleFlowCandidate'],
                jet_algorithm='anti_kt',
                radius=0.4,
                jet_name='AntiKt04PFJetsBQuark'
            ).PtFilter(25.).EtaFilter(4.)
             .GhostAssociation('TruthBChildren', 0, mode='filter'),

            jets.JetFinder(
                ['ParticleFlowCandidate'],
                jet_algorithm='anti_kt',
                radius=0.4,
                jet_name='AntiKt04PFJetsBAntiQuark'
            ).PtFilter(25.).EtaFilter(4.)
             .GhostAssociation('TruthBChildren', 0, mode='filter'),

            jets.JetFinder(
                ['Track'],
                jet_algorithm='anti_kt',
                radius=0.4,
                jet_name='AntiKt04TrackJetsBQuark'
            ).PtFilter(5.).EtaFilter(4.)
             .GhostAssociation('TruthBChildren', 0, mode='filter'),

            jets.JetFinder(
                ['Track'],
                jet_algorithm='anti_kt',
                radius=0.4,
                jet_name='AntiKt04TrackJetsBAntiQuark'
            ).PtFilter(5.).EtaFilter(4.)
             .GhostAssociation('TruthBChildren', 0, mode='filter'),
        ]
    }
}
