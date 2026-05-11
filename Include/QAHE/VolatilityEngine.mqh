#ifndef __QAHE_VOLENGINE_MQH__
#define __QAHE_VOLENGINE_MQH__

#include "Utilities.mqh"
#include "Types.mqh"

class CVolatilityEngine
  {
private:
   int m_atrHandle;
public:
   bool Init(string symbol,ENUM_TIMEFRAMES tf,int period)
     {
      m_atrHandle=iATR(symbol,tf,period);
      return (m_atrHandle!=INVALID_HANDLE);
     }
   bool Update(double &natr,double &expansion,VolatilityRegime &regime)
     {
      double atr[2];
      if(CopyBuffer(m_atrHandle,0,0,2,atr)<2) return false;
      double close=iClose(_Symbol,_Period,0);
      natr=SafeDiv(atr[0],close,0.0);
      expansion=SafeDiv(atr[0],atr[1],1.0);
      if(natr<0.0015) regime=VR_COMPRESSION;
      else if(natr<0.0035) regime=VR_NORMAL;
      else if(natr<0.0060) regime=VR_EXPANSION;
      else regime=VR_PANIC;
      return true;
     }
   double Score(double natr,double expansion)
     {
      double s=0.6*Normalize01(natr,0.0010,0.0065)+0.4*Normalize01(expansion,0.8,1.6);
      return Clamp(s,0.0,1.0);
     }
  };

#endif
