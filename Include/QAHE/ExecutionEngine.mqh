#ifndef __QAHE_EXEC_MQH__
#define __QAHE_EXEC_MQH__

#include <Trade/Trade.mqh>
#include "Logger.mqh"

class CExecutionEngine
  {
private:
   CTrade m_trade;
   CLogger *m_log;
public:
   void Init(CLogger &log,int slippage){ m_log=&log; m_trade.SetDeviationInPoints(slippage); }
   bool SpreadOk(double maxSpreadPoints)
     {
      double spread=(SymbolInfoDouble(_Symbol,SYMBOL_ASK)-SymbolInfoDouble(_Symbol,SYMBOL_BID))/_Point;
      return spread<=maxSpreadPoints;
     }
   bool Execute(bool buy,double lots,string comment,int retries)
     {
      for(int i=0;i<=retries;i++)
        {
         bool ok=buy?m_trade.Buy(lots,_Symbol,0,0,0,comment):m_trade.Sell(lots,_Symbol,0,0,0,comment);
         if(ok){ m_log.Info("Order filled "+comment); return true; }
        }
      m_log.Error("Order failed "+comment);
      return false;
     }
  };

#endif
