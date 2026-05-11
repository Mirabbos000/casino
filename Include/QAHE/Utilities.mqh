#ifndef __QAHE_UTILITIES_MQH__
#define __QAHE_UTILITIES_MQH__

double Clamp(double x,double lo,double hi){ return MathMax(lo,MathMin(hi,x)); }
double SafeDiv(double a,double b,double d=0.0){ return (MathAbs(b)<1e-9)?d:a/b; }

double Normalize01(double value,double lo,double hi)
  {
   if(hi<=lo) return 0.0;
   return Clamp((value-lo)/(hi-lo),0.0,1.0);
  }

#endif
