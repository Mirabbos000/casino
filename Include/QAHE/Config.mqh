#ifndef __QAHE_CONFIG_MQH__
#define __QAHE_CONFIG_MQH__

input string InpSymbol               = "XAUUSD";
input ENUM_TIMEFRAMES InpTF          = PERIOD_M15;
input int    InpATRPeriod            = 14;
input int    InpVolLookback          = 100;
input int    InpEntropyLookback      = 64;
input double InpEntropyCutoff        = 0.80;
input double InpTradeThreshold       = 0.62;

input double InpWVolatility          = 0.22;
input double InpWEntropy             = 0.18;
input double InpWLiquidity           = 0.18;
input double InpWTrend               = 0.20;
input double InpWZones               = 0.22;

input double InpRiskPct              = 0.35;
input double InpKellyFraction        = 0.25;
input bool   InpUseHalfKelly         = false;
input double InpMaxDailyLossPct      = 2.5;
input double InpMaxDrawdownPct       = 8.0;
input double InpMaxExposureLots      = 3.0;
input int    InpMaxHedgeDepth        = 3;

input double InpHedgeBaseRatio       = 0.30;
input double InpHedgeMaxRatio        = 0.60;

input double InpMaxSpreadPoints      = 80;
input int    InpMaxSlippagePoints    = 40;
input int    InpOrderRetries         = 2;

#endif
