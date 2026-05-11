#ifndef __QAHE_TYPES_MQH__
#define __QAHE_TYPES_MQH__

enum EAState
  {
   STATE_WAIT=0,
   STATE_SCAN,
   STATE_ENTRY,
   STATE_MANAGE,
   STATE_HEDGE,
   STATE_RECOVERY,
   STATE_UNWIND,
   STATE_STOP
  };

enum VolatilityRegime
  {
   VR_COMPRESSION=0,
   VR_NORMAL,
   VR_EXPANSION,
   VR_PANIC
  };

struct ProbabilityFeatures
  {
   double volatility;
   double entropy;
   double liquidity;
   double trend;
   double zones;
   double momentum;
  };

struct ExposureSnapshot
  {
   double totalLots;
   double hedgeLots;
   double marginUsagePct;
   double floatingDDPct;
   int    hedgeDepth;
  };

struct MonteCarloMetrics
  {
   double maxDD;
   double avgDD;
   double ruinProbability;
   double sharpe;
   double recoveryBars;
   double worstEquity;
   bool   safe;
  };

#endif
