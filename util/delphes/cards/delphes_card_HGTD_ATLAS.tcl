########################################
# HGTD + ATLAS Card
#Author: Riccardo Campara
########################################

set RandomSeed 203

#######################################
# Global Parameters (from TDR)
#######################################

set B 2.0

set HGTD_ZPOS    3.5
set HGTD_RMIN    0.120
set HGTD_RMAX    0.640
set HGTD_ETA_MIN 2.4
set HGTD_ETA_MAX 4.0

set R_prop  1.15
set HL_prop 3.62;     #see position of the last HGTD layer in the geometry

set BeamSpotSigmaZ 46.0    ;# mm, HL-LHC nominale
set BeamSpotSigmaT 180e-12 ;# s

#######################################
# Execution Path
#######################################

set ExecutionPath {

  PileUpMerger
  TruthVertexFinder
  ParticlePropagator

  ChargedHadronTrackingEfficiency
  ElectronTrackingEfficiency
  MuonTrackingEfficiency

  ChargedHadronMomentumSmearing
  ElectronMomentumSmearing
  MuonMomentumSmearing

  TrackMergerPre
  TrackSmearing

  TimeSmearing
  TimeOfFlight
  TrackMerger

  Calorimeter
  ElectronFilter
  TrackPileUpSubtractor
  NeutralTowerMerger
  EFlowMergerAllTracks
  EFlowMerger
  EFlowFilter

  HGTDNeutralFilter
  TimeSmearingNeutrals
  TimeOfFlightNeutrals

  Rho
  NeutrinoFilter

  GenJetFinder
  GenMissingET

  FastJetFinder
  JetPileUpSubtractor
  JetEnergyScale

  PhotonEfficiency
  PhotonIsolation

  ElectronEfficiency
  ElectronIsolation

  MuonEfficiency
  MuonIsolation

  JetFlavorAssociation
  BTagging
  TauTagging

  UniqueObjectFinder

  MissingET
  ScalarHT

  TreeWriter
}

#######################################
# PileUp Merger
#######################################

module PileUpMerger PileUpMerger {
  set InputArray Delphes/stableParticles
  set ParticleOutputArray stableParticles
  set VertexOutputArray vertices

  set PileUpFile /HEPData4ML/external/delphes/MinBias.pileup;

  set MeanPileUp 200

  # longitudinal spread: sigma_z = 46 mm, limit ~5 sigma
  set ZVertexSpread 0.25

  # Temporal Spread: sigma_t ~ 153 ps (HL-LHC), limit ~5 sigma
  set TVertexSpread 750E-12
  set VertexDistributionFormula {exp(-(t^2/153e-12^2/2))*exp(-(z^2/0.046^2/2))}
}

#################################
# Truth Vertex Finder
#################################

module TruthVertexFinder TruthVertexFinder {
  set Resolution 1E-03
  set InputArray PileUpMerger/stableParticles
  set VertexOutputArray vertices
}

#################################
# Particle Propagator
#################################

module ParticlePropagator ParticlePropagator {
  set InputArray PileUpMerger/stableParticles

  set OutputArray stableParticles
  set ChargedHadronOutputArray chargedHadrons
  set ElectronOutputArray electrons
  set MuonOutputArray muons

  set Radius     $R_prop
  set HalfLength $HL_prop
  set Bz $B
}

########################################
# Tracking efficiency
########################################

module Efficiency ChargedHadronTrackingEfficiency {
  set InputArray ParticlePropagator/chargedHadrons
  set OutputArray chargedHadrons
  set UseMomentumVector true

  set EfficiencyFormula {
    (pt <= 0.5)                                              * (0.00) +
    (abs(eta) > 4.0)                                         * (0.00) +
    (abs(eta) <= 1.5)   * (pt > 0.5 && pt <= 5.0)           * (0.85) +
    (abs(eta) <= 1.5)   * (pt > 5.0)                        * (0.90) +
    (abs(eta) > 1.5  && abs(eta) <= 2.5) * (pt > 0.5 && pt <= 5.0) * (0.75) +
    (abs(eta) > 1.5  && abs(eta) <= 2.5) * (pt > 5.0)       * (0.80) +
    (abs(eta) > 2.5  && abs(eta) <= 4.0) * (pt < 1.0)       * (0.00) +
    (abs(eta) > 2.5  && abs(eta) <= 4.0) * (pt >= 1.0)      * (1.00)
  }
}

module Efficiency ElectronTrackingEfficiency {
  set InputArray ParticlePropagator/electrons
  set OutputArray electrons
  set UseMomentumVector true

  set EfficiencyFormula {
    (pt <= 0.5)                                              * (0.00) +
    (abs(eta) > 4.0)                                         * (0.00) +
    (abs(eta) <= 1.5)   * (pt > 0.5 && pt <= 5.0)           * (0.85) +
    (abs(eta) <= 1.5)   * (pt > 5.0)                        * (0.90) +
    (abs(eta) > 1.5  && abs(eta) <= 2.5) * (pt > 0.5 && pt <= 5.0) * (0.75) +
    (abs(eta) > 1.5  && abs(eta) <= 2.5) * (pt > 5.0)       * (0.80) +
    (abs(eta) > 2.5  && abs(eta) <= 4.0) * (pt < 1.0)       * (0.00) +
    (abs(eta) > 2.5  && abs(eta) <= 4.0) * (pt >= 1.0)      * (1.00)
  }
}

module Efficiency MuonTrackingEfficiency {
  set InputArray ParticlePropagator/muons
  set OutputArray muons
  set UseMomentumVector true

  set EfficiencyFormula {
    (pt <= 0.5)                                              * (0.00) +
    (abs(eta) > 4.0)                                         * (0.00) +
    (abs(eta) <= 1.5)   * (pt > 0.5 && pt <= 5.0)           * (0.85) +
    (abs(eta) <= 1.5)   * (pt > 5.0)                        * (0.90) +
    (abs(eta) > 1.5  && abs(eta) <= 2.5) * (pt > 0.5 && pt <= 5.0) * (0.75) +
    (abs(eta) > 1.5  && abs(eta) <= 2.5) * (pt > 5.0)       * (0.80) +
    (abs(eta) > 2.5  && abs(eta) <= 4.0) * (pt < 1.0)       * (0.00) +
    (abs(eta) > 2.5  && abs(eta) <= 4.0) * (pt >= 1.0)      * (1.00)
  }
}

########################################
# Momentum smearing
########################################

module MomentumSmearing ChargedHadronMomentumSmearing {
  set InputArray ChargedHadronTrackingEfficiency/chargedHadrons
  set OutputArray chargedHadrons

  set ResolutionFormula {
    (abs(eta) <= 0.5)                    * (pt > 0.1) * sqrt(0.06^2  + pt^2*1.3e-3^2) +
    (abs(eta) > 0.5 && abs(eta) <= 1.5) * (pt > 0.1) * sqrt(0.10^2  + pt^2*1.7e-3^2) +
    (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1) * sqrt(0.25^2  + pt^2*3.1e-3^2) +
    (abs(eta) > 2.5)                                  * (0.0)
  }
}

module MomentumSmearing ElectronMomentumSmearing {
  set InputArray ElectronTrackingEfficiency/electrons
  set OutputArray electrons

  set ResolutionFormula {
    (abs(eta) <= 0.5)                    * (pt > 0.1) * sqrt(0.03^2  + pt^2*1.3e-3^2) +
    (abs(eta) > 0.5 && abs(eta) <= 1.5) * (pt > 0.1) * sqrt(0.05^2  + pt^2*1.7e-3^2) +
    (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1) * sqrt(0.15^2  + pt^2*3.1e-3^2) +
    (abs(eta) > 2.5)                                  * (0.0)
  }
}

module MomentumSmearing MuonMomentumSmearing {
  set InputArray MuonTrackingEfficiency/muons
  set OutputArray muons

  set ResolutionFormula {
    (abs(eta) <= 0.5)                    * (pt > 0.1) * sqrt(0.01^2  + pt^2*1.0e-4^2) +
    (abs(eta) > 0.5 && abs(eta) <= 1.5) * (pt > 0.1) * sqrt(0.015^2 + pt^2*1.5e-4^2) +
    (abs(eta) > 1.5 && abs(eta) <= 2.5) * (pt > 0.1) * sqrt(0.025^2 + pt^2*3.5e-4^2) +
    (abs(eta) > 2.5)                                  * (0.0)
  }
}

module Merger TrackMergerPre {
  add InputArray ChargedHadronMomentumSmearing/chargedHadrons
  add InputArray ElectronMomentumSmearing/electrons
  add InputArray MuonMomentumSmearing/muons
  set OutputArray tracks
  set PTMin 0.5 
}

########################################
# TrackCovariance — Full Geometry HGTD
# (ITK barrel/disk + DCH + BSILWRP + HGTD layers)
########################################

module TrackCovariance TrackSmearing {

  set InputArray TrackMergerPre/tracks
  set OutputArray tracks

  set NMinHits 3
  set PtMin 1
  set Bz $B

  set DetectorGeometry {

    1 VTXLOW  -0.0965  0.0965  0.0137   0.000309  0.0937  2  0  1.5708  3e-06   3e-06   1
    1 VTXLOW  -0.1609  0.1609  0.0237   0.000309  0.0937  2  0  1.5708  3e-06   3e-06   1
    1 VTXLOW  -0.257   0.257   0.0340   0.000309  0.0937  2  0  1.5708  3e-06   3e-06   1
    1 VTXHIGH -0.1631  0.1631  0.141    0.000415  0.0937  2  0  1.5708  3e-06   3e-06   1
    1 VTXHIGH -0.340   0.340   0.315    0.000415  0.0937  2  0  1.5708  7e-06   7e-06   1
    1 DCHCANI -2.125   2.125   0.345    0.0002    0.237223 0  0  0       0       0       0
    1 DCH     -2       2       0.36     0.0147748 579     1  0.0203738  0  0.0001  0  1
    1 DCH     -2       2       0.374775 0.0147748 579     1  -0.0212097 0  0.0001  0  1
    1 DCH     -2       2       0.38955  0.0147748 579     1  0.0220456  0  0.0001  0  1
    1 DCH     -2       2       0.404324 0.0147748 579     1  -0.0228814 0  0.0001  0  1
    1 DCH     -2       2       0.419099 0.0147748 579     1  0.0237172  0  0.0001  0  1
    1 DCH     -2       2       0.433874 0.0147748 579     1  -0.024553  0  0.0001  0  1
    1 DCH     -2       2       0.448649 0.0147748 579     1  0.0253888  0  0.0001  0  1
    1 DCH     -2       2       0.463423 0.0147748 579     1  -0.0262245 0  0.0001  0  1
    1 DCH     -2       2       0.478198 0.0147748 579     1  0.0270602  0  0.0001  0  1
    1 DCH     -2       2       0.492973 0.0147748 579     1  -0.0278958 0  0.0001  0  1
    1 DCH     -2       2       0.507748 0.0147748 579     1  0.0287314  0  0.0001  0  1
    1 DCH     -2       2       0.522523 0.0147748 579     1  -0.029567  0  0.0001  0  1
    1 DCHCANO -2.125   2.125   2.02     0.02      1.667   0  0  0       0       0       0
    1 BSILWRP -2.35    2.35    2.04     0.00047   0.0937  2  0  1.5708  7e-006  9e-005  1
    1 BSILWRP -2.35    2.35    2.06     0.00047   0.0937  2  0  1.5708  7e-006  9e-005  1
    1 MAG     -2.5     2.5     2.25     0.05      0.0658  0  0  0       0       0       0
    1 BPRESH  -2.55    2.55    2.45     0.02      1       2  0  1.5708  7e-005  0.01    1
    2 VTXDSK   0.108   0.3    -0.93     0.000909  0.0937  2  0  1.5708  7e-06   7e-06   1
    2 VTXDSK   0.073   0.3    -0.62     0.000909  0.0937  2  0  1.5708  7e-06   7e-06   1
    2 VTXDSK   0.034   0.28   -0.3023   0.000909  0.0937  2  0  1.5708  7e-06   7e-06   1
    2 VTXDSK   0.034   0.28    0.3023   0.000909  0.0937  2  0  1.5708  7e-06   7e-06   1
    2 VTXDSK   0.073   0.3     0.62     0.000909  0.0937  2  0  1.5708  7e-06   7e-06   1
    2 VTXDSK   0.108   0.3     0.93     0.000909  0.0937  2  0  1.5708  7e-06   7e-06   1
    2 FSILWRP  0.30    2.02   -2.32     0.00047   0.0937  2  0  1.5708  7e-006  9e-005  1
    2 FSILWRP  0.30    2.02   -2.3      0.00047   0.0937  2  0  1.5708  7e-006  9e-005  1
    2 FSILWRP  0.30    2.02    2.3      0.00047   0.0937  2  0  1.5708  7e-006  9e-005  1
    2 FSILWRP  0.30    2.02    2.32     0.00047   0.0937  2  0  1.5708  7e-006  9e-005  1
    2 FPRESH   0.39    2.43   -2.55     0.02      1       2  0  1.5708  7e-005  0.01    1
    2 FPRESH   0.39    2.43    2.55     0.02      1       2  0  1.5708  7e-005  0.01    1

    1 ITK_REF  -3.0    3.0     0.280    0.001     0.094   0  0  0       0       0       0

    2 SERVICES  0.12   0.64   -3.40     0.010     0.350   0  0  0       0       0       0
    2 SERVICES  0.12   0.64    3.40     0.010     0.350   0  0  0       0       0       0

    2 MODERATOR 0.12   0.64   -3.45     0.050     0.400   0  0  0       0       0       0
    2 MODERATOR 0.12   0.64    3.45     0.050     0.400   0  0  0       0       0       0

    2 VESSEL_FRONT  0.110  1.000  -3.475  0.001  0.089   0  0  0       0       0       0
    2 VESSEL_FRONT  0.110  1.000   3.475  0.001  0.089   0  0  0       0       0       0

    2 HGTD_L0  0.120   0.640  -3.490    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L1  0.120   0.640  -3.505    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L2  0.120   0.640  -3.515    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L3  0.120   0.640  -3.530    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L0  0.120   0.640   3.490    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L1  0.120   0.640   3.505    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L2  0.120   0.640   3.515    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1
    2 HGTD_L3  0.120   0.640   3.530    0.0003    0.0937  2  0  1.5708  3.75e-4 3.75e-4 1

    2 VESSEL_BACK  0.110  1.000  -3.600  0.002  0.089    0  0  0       0       0       0
    2 VESSEL_BACK  0.110  1.000   3.600  0.002  0.089    0  0  0       0       0       0
  }
}

########################################
# Time Smearing HGTD
########################################

module TimeSmearing TimeSmearing {
  set InputArray TrackSmearing/tracks
  set OutputArray tracks

  set TimeResolution {
    (abs(eta) < 2.4 || abs(eta) > 4.0)           * (0.0)      +
    (abs(eta) >= 2.4 && abs(eta) < 2.7)           * (24.7E-12) +
    (abs(eta) >= 2.7 && abs(eta) < 3.5)           * (22.6E-12) +
    (abs(eta) >= 3.5 && abs(eta) <= 4.0)          * (21.7E-12)
  }
}

########################################
# Time Of Flight (tracce cariche)
########################################

module TimeOfFlight TimeOfFlight {
  set InputArray TimeSmearing/tracks
  set VertexInputArray TruthVertexFinder/vertices
  set OutputArray tracks
  set VertexTimeMode 1
}

module Merger TrackMerger {
  add InputArray TimeOfFlight/tracks
  set OutputArray tracks
}

#############
# Calorimeter
#############

module Calorimeter Calorimeter {
  set ParticleInputArray ParticlePropagator/stableParticles
  set TrackInputArray TrackSmearing/tracks

  set TowerOutputArray towers
  set PhotonOutputArray photons

  set EFlowTrackOutputArray eflowTracks
  set EFlowPhotonOutputArray eflowPhotons
  set EFlowNeutralHadronOutputArray eflowNeutralHadrons

  set ECalEnergyMin 0.5
  set HCalEnergyMin 1.0

  set ECalEnergySignificanceMin 1.0
  set HCalEnergySignificanceMin 1.0

  set SmearTowerCenter true

  set pi [expr {acos(-1)}]

  set PhiBins {}
  for {set i -18} {$i <= 18} {incr i} {
    add PhiBins [expr {$i * $pi/18.0}]
  }
  foreach eta {-3.2 -2.5 -2.4 -2.3 -2.2 -2.1 -2 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 2.1 2.2 2.3 2.4 2.5 2.6 3.3} {
    add EtaPhiBins $eta $PhiBins
  }

  set PhiBins {}
  for {set i -9} {$i <= 9} {incr i} {
    add PhiBins [expr {$i * $pi/9.0}]
  }
  foreach eta {-4.9 -4.7 -4.5 -4.3 -4.1 -3.9 -3.7 -3.5 -3.3 -3 -2.8 -2.6 2.8 3 3.2 3.5 3.7 3.9 4.1 4.3 4.5 4.7 4.9} {
    add EtaPhiBins $eta $PhiBins
  }

  add EnergyFraction {0}       {0.0 1.0}
  add EnergyFraction {11}      {1.0 0.0}
  add EnergyFraction {22}      {1.0 0.0}
  add EnergyFraction {111}     {1.0 0.0}
  add EnergyFraction {12}      {0.0 0.0}
  add EnergyFraction {13}      {0.0 0.0}
  add EnergyFraction {14}      {0.0 0.0}
  add EnergyFraction {16}      {0.0 0.0}
  add EnergyFraction {1000022} {0.0 0.0}
  add EnergyFraction {1000023} {0.0 0.0}
  add EnergyFraction {1000025} {0.0 0.0}
  add EnergyFraction {1000035} {0.0 0.0}
  add EnergyFraction {1000045} {0.0 0.0}
  add EnergyFraction {310}     {0.3 0.7}
  add EnergyFraction {3122}    {0.3 0.7}

  set ECalResolutionFormula {
    (abs(eta) <= 3.2)                    * sqrt(energy^2*0.0017^2 + energy*0.101^2) +
    (abs(eta) > 3.2 && abs(eta) <= 4.9) * sqrt(energy^2*0.0350^2 + energy*0.285^2)
  }

  set HCalResolutionFormula {
    (abs(eta) <= 1.7)                    * sqrt(energy^2*0.0302^2 + energy*0.5205^2 + 1.59^2) +
    (abs(eta) > 1.7 && abs(eta) <= 3.2) * sqrt(energy^2*0.0500^2 + energy*0.706^2)            +
    (abs(eta) > 3.2 && abs(eta) <= 4.9) * sqrt(energy^2*0.0942^2 + energy*1.00^2)
  }
}

#################
# Electron filter
#################

module PdgCodeFilter ElectronFilter {
  set InputArray Calorimeter/eflowTracks
  set OutputArray electrons
  set Invert true
  add PdgCode {11}
  add PdgCode {-11}
}

##########################
# Track pile-up subtractor
##########################

module TrackPileUpSubtractor TrackPileUpSubtractor {
  add InputArray Calorimeter/eflowTracks eflowTracks
  add InputArray ElectronFilter/electrons electrons
  add InputArray MuonTrackingEfficiency/muons muons;  
  set ZVertexResolution {0.0001}
}

####################
# Neutral tower merger
####################

module Merger NeutralTowerMerger {
  add InputArray Calorimeter/eflowPhotons
  add InputArray Calorimeter/eflowNeutralHadrons
  set OutputArray eflowTowers
}

module Merger EFlowMergerAllTracks {
  add InputArray TrackSmearing/tracks
  add InputArray Calorimeter/eflowPhotons
  add InputArray Calorimeter/eflowNeutralHadrons
  set OutputArray eflow
}

module Merger EFlowMerger {
  add InputArray Calorimeter/eflowTracks
  add InputArray Calorimeter/eflowPhotons
  add InputArray Calorimeter/eflowNeutralHadrons
  set OutputArray eflow
}

module PdgCodeFilter EFlowFilter {
  set InputArray EFlowMerger/eflow
  set OutputArray eflow
  add PdgCode {11}
  add PdgCode {-11}
  add PdgCode {13}
  add PdgCode {-13}
}

########################################
# Neutral hadrons HGTD (forward only)
########################################

module PdgCodeFilter HGTDNeutralFilter {
  set InputArray PileUpMerger/stableParticles
  set OutputArray neutrals
  set Invert false
  add PdgCode {2112};   
  add PdgCode {-2112};  
  add PdgCode {130};   
}

module TimeSmearing TimeSmearingNeutrals {
  set InputArray HGTDNeutralFilter/neutrals
  set OutputArray neutrals

  set TimeResolution {
    (abs(eta) >= 2.4 && abs(eta) <= 4.0) * (100E-12) +
    (abs(eta) < 2.4 || abs(eta) > 4.0)  * (0.0)
  }
}

module TimeOfFlight TimeOfFlightNeutrals {
  set InputArray TimeSmearingNeutrals/neutrals
  set VertexInputArray TruthVertexFinder/vertices
  set OutputArray neutrals
  set VertexTimeMode 1
}

#############
# Rho pile-up
#############

module FastJetGridMedianEstimator Rho {
  set InputArray Calorimeter/towers
  set RhoOutputArray rho

  add GridRange -5.0 -2.5 1.0 1.0
  add GridRange -2.5  2.5 0.5 0.5
  add GridRange  2.5  5.0 1.0 1.0
}

#####################
# Neutrino Filter
#####################

module PdgCodeFilter NeutrinoFilter {
  set InputArray PileUpMerger/stableParticles; 
  set OutputArray filteredParticles
  set PTMin 0.0
  add PdgCode {12}
  add PdgCode {14}
  add PdgCode {16}
  add PdgCode {-12}
  add PdgCode {-14}
  add PdgCode {-16}
}

#####################
# Jet finders
#####################

module FastJetFinder GenJetFinder {
  set InputArray NeutrinoFilter/filteredParticles
  set OutputArray jets
  set JetAlgorithm 6
  set ParameterR 0.4
  set JetPTMin 20.0
}

module Merger GenMissingET {
  add InputArray NeutrinoFilter/filteredParticles
  set MomentumOutputArray momentum
}

module FastJetFinder FastJetFinder {
  set InputArray Calorimeter/towers
  set OutputArray jets
  set AreaAlgorithm 5
  set JetAlgorithm 6
  set ParameterR 0.4
  set JetPTMin 20.0
}

module JetPileUpSubtractor JetPileUpSubtractor {
  set JetInputArray FastJetFinder/jets
  set RhoInputArray Rho/rho
  set OutputArray jets
  set JetPTMin 20.0
}

module EnergyScale JetEnergyScale {
  set InputArray JetPileUpSubtractor/jets
  set OutputArray jets
  set ScaleFormula {1.0}
}

###################
# Photon efficiency
###################

module Efficiency PhotonEfficiency {
  set InputArray Calorimeter/eflowPhotons
  set OutputArray photons

  set EfficiencyFormula {
                                             (pt <= 10.0) * (0.00) +
                         (abs(eta) <= 1.5) * (pt > 10.0)  * (0.95) +
    (abs(eta) > 1.5 && abs(eta) <= 2.5)   * (pt > 10.0)  * (0.85) +
    (abs(eta) > 2.5 && abs(eta) <= 4.0)   * (pt > 10.0)  * (0.60) +
    (abs(eta) > 4.0)                                       * (0.00)
  }
}

module Isolation PhotonIsolation {
  set CandidateInputArray PhotonEfficiency/photons
  set IsolationInputArray EFlowFilter/eflow
  set RhoInputArray Rho/rho
  set OutputArray photons
  set DeltaRMax 0.5
  set PTMin 0.5
  set PTRatioMax 0.12
}

#####################
# Electron efficiency
#####################

module Efficiency ElectronEfficiency {
  set InputArray TrackPileUpSubtractor/electrons
  set OutputArray electrons

  set EfficiencyFormula {
                                             (pt <= 10.0) * (0.00) +
                         (abs(eta) <= 1.5) * (pt > 10.0)  * (0.95) +
    (abs(eta) > 1.5 && abs(eta) <= 2.5)   * (pt > 10.0)  * (0.85) +
    (abs(eta) > 2.5 && abs(eta) <= 4.0)   * (pt >= 1.0)  * (0.99) +
    (abs(eta) > 4.0)                                       * (0.00)
  }
}

module Isolation ElectronIsolation {
  set CandidateInputArray ElectronEfficiency/electrons
  set IsolationInputArray EFlowFilter/eflow
  set RhoInputArray Rho/rho
  set OutputArray electrons
  set DeltaRMax 0.5
  set PTMin 0.5
  set PTRatioMax 0.12
}

#################
# Muon efficiency
#################

module Efficiency MuonEfficiency {
  set InputArray TrackPileUpSubtractor/muons
  set OutputArray muons

  set EfficiencyFormula {
                                             (pt <= 10.0) * (0.00) +
                         (abs(eta) <= 1.5) * (pt > 10.0)  * (0.95) +
    (abs(eta) > 1.5 && abs(eta) <= 2.7)   * (pt > 10.0)  * (0.85) +
    (abs(eta) > 2.7 && abs(eta) <= 4.0)   * (pt >= 1.0)  * (0.99) +
    (abs(eta) > 4.0)                                       * (0.00)
  }
}

module Isolation MuonIsolation {
  set CandidateInputArray MuonEfficiency/muons
  set IsolationInputArray EFlowFilter/eflow
  set RhoInputArray Rho/rho
  set OutputArray muons
  set DeltaRMax 0.5
  set PTMin 0.5
  set PTRatioMax 0.25
}

###################
# Missing ET
###################

module Merger MissingET {
  add InputArray TrackPileUpSubtractor/eflowTracks ;     
  add InputArray Calorimeter/eflowPhotons
  add InputArray Calorimeter/eflowNeutralHadrons
  set MomentumOutputArray momentum
}

module Merger ScalarHT {
  add InputArray UniqueObjectFinder/jets
  add InputArray UniqueObjectFinder/electrons
  add InputArray UniqueObjectFinder/photons
  add InputArray UniqueObjectFinder/muons
  set EnergyOutputArray energy
}

########################
# Jet Flavor Association
########################

module JetFlavorAssociation JetFlavorAssociation {
  set PartonInputArray Delphes/partons
  set ParticleInputArray Delphes/allParticles
  set ParticleLHEFInputArray Delphes/allParticlesLHEF
  set JetInputArray JetEnergyScale/jets
  set DeltaR 0.4
  set PartonPTMin 1.0
  set PartonEtaMax 4.0
}

###########
# b-tagging
###########

module BTagging BTagging {
  set JetInputArray JetEnergyScale/jets
  set BitNumber 0

  # misidentification rate (light jets) — ATL-PHYS-PUB-2015-022
  add EfficiencyFormula {0} {0.002+7.3e-06*pt}
  # c-jets (misidentification rate)
  add EfficiencyFormula {4} {0.20*tanh(0.02*pt)*(1/(1+0.0034*pt))}
  # b-jets
  add EfficiencyFormula {5} {0.80*tanh(0.003*pt)*(30/(1+0.086*pt))}
}

#############
# tau-tagging
#############

module TrackCountingTauTagging TauTagging {
  set ParticleInputArray Delphes/allParticles
  set PartonInputArray Delphes/partons
  set TrackInputArray TrackSmearing/tracks
  set JetInputArray JetEnergyScale/jets
  set DeltaR 0.2
  set DeltaRTrack 0.2
  set TrackPTMin 1.0
  set TauPTMin 1.0
  set TauEtaMax 4.0 ; 
  set BitNumber 0
  
  add EfficiencyFormula {1}  {0.70}
  add EfficiencyFormula {2}  {0.60}
  add EfficiencyFormula {-1} {0.02}
  add EfficiencyFormula {-2} {0.01}
}

#####################################################
# UniqueObjectFinder
#####################################################

module UniqueObjectFinder UniqueObjectFinder {
  add InputArray PhotonIsolation/photons    photons
  add InputArray ElectronIsolation/electrons electrons
  add InputArray MuonIsolation/muons        muons
  add InputArray JetEnergyScale/jets        jets
}

##################
# ROOT Tree Writer
##################

module TreeWriter TreeWriter {

  add Branch Delphes/allParticles           Particle        GenParticle
  add Branch PileUpMerger/vertices          PileUpVertices  Vertex
  add Branch TruthVertexFinder/vertices     GenVertex       Vertex

  add Branch TrackMerger/tracks             Track           Track
  add Branch TimeSmearing/tracks            TrackSmeared    Track

  add Branch Calorimeter/towers             Tower           Tower
  add Branch EFlowMerger/eflow              ParticleFlowCandidate ParticleFlowCandidate

  add Branch UniqueObjectFinder/electrons   Electron        Electron
  add Branch UniqueObjectFinder/photons     Photon          Photon
  add Branch UniqueObjectFinder/muons       Muon            Muon
  add Branch UniqueObjectFinder/jets        Jet             Jet
  add Branch GenJetFinder/jets              GenJet          Jet
  add Branch GenMissingET/momentum          GenMissingET    MissingET
  add Branch MissingET/momentum             MissingET       MissingET
  add Branch ScalarHT/energy                ScalarHT        ScalarHT
  add Branch Rho/rho                        Rho             Rho

  add Info Bz                   $B
  add Info HGTD_ZPOS            $HGTD_ZPOS
  add Info HGTD_RMIN            $HGTD_RMIN
  add Info HGTD_RMAX            $HGTD_RMAX
  add Info HGTD_ETA_MIN         $HGTD_ETA_MIN
  add Info HGTD_ETA_MAX         $HGTD_ETA_MAX
  add Info PropagatorRadius     $R_prop
  add Info PropagatorHalfLength $HL_prop
}