#property strict

#include "../Include/QAHE/Config.mqh"
#include "../Include/QAHE/Types.mqh"
#include "../Include/QAHE/Logger.mqh"
#include "../Include/QAHE/Utilities.mqh"
#include "../Include/QAHE/StateMachine.mqh"
#include "../Include/QAHE/VolatilityEngine.mqh"
#include "../Include/QAHE/EntropyEngine.mqh"
#include "../Include/QAHE/ProbabilityEngine.mqh"
#include "../Include/QAHE/RiskEngine.mqh"
#include "../Include/QAHE/HedgeEngine.mqh"
#include "../Include/QAHE/SurvivalEngine.mqh"
#include "../Include/QAHE/ExecutionEngine.mqh"
#include "../Include/QAHE/MonteCarloEngine.mqh"

CLogger g_log;
CStateMachine g_sm;
CVolatilityEngine g_vol;
CEntropyEngine g_entropy;
CProbabilityEngine g_prob;
CRiskEngine g_risk;
CHedgeEngine g_hedge;
CSurvivalEngine g_survival;
CExecutionEngine g_exec;

int OnInit()
  {
   g_sm.Init(g_log);
   g_prob.Configure(InpWVolatility,InpWEntropy,InpWLiquidity,InpWTrend,InpWZones);
   g_exec.Init(g_log,InpMaxSlippagePoints);
   if(!g_vol.Init(InpSymbol,InpTF,InpATRPeriod)) return INIT_FAILED;
   g_log.Info("QAHE initialized (survival-first, non-martingale)");
   return INIT_SUCCEEDED;
  }

void OnTick()
  {
   if(g_sm.State()==STATE_STOP) return;
   g_sm.Transition(STATE_SCAN,"tick");

   double natr,expansion; VolatilityRegime regime;
   if(!g_vol.Update(natr,expansion,regime)) return;
   double volScore=g_vol.Score(natr,expansion);
   double entScore=g_entropy.Compute(InpEntropyLookback);

   ExposureSnapshot ex={0};
   ex.floatingDDPct=SafeDiv(AccountInfoDouble(ACCOUNT_BALANCE)-AccountInfoDouble(ACCOUNT_EQUITY),AccountInfoDouble(ACCOUNT_BALANCE),0.0)*100.0;

   bool panic=g_survival.PanicMode(regime,entScore,ex.floatingDDPct);
   if(panic){ g_sm.EmergencyStop("panic mode"); return; }

   ProbabilityFeatures f;
   f.volatility=volScore; f.entropy=entScore;
   f.liquidity=0.50; f.trend=0.55; f.zones=0.60; f.momentum=0.52; // zone/microstructure hooks

   double pEdge=g_prob.Score(f);
   if(entScore>InpEntropyCutoff){ g_sm.Transition(STATE_WAIT,"entropy filter"); return; }

   if(pEdge>=InpTradeThreshold && g_exec.SpreadOk(InpMaxSpreadPoints))
     {
      g_sm.Transition(STATE_ENTRY,"probability pass");
      double atr=iATR(InpSymbol,InpTF,InpATRPeriod,0);
      double kelly=(InpUseHalfKelly?0.5:InpKellyFraction);
      double lot=g_risk.ComputeLot(AccountInfoDouble(ACCOUNT_EQUITY),InpRiskPct,atr,MathMax(0.5,volScore),kelly);
      lot=NormalizeDouble(lot,2);
      if(lot>0.0) g_exec.Execute(true,lot,"QAHE_ENTRY",InpOrderRetries);
      g_sm.Transition(STATE_MANAGE,"entry sent");
     }
   else g_sm.Transition(STATE_WAIT,"no edge");
  }
