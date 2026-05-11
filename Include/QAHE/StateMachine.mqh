#ifndef __QAHE_STATEMACHINE_MQH__
#define __QAHE_STATEMACHINE_MQH__

#include "Logger.mqh"
#include "Types.mqh"

class CStateMachine
  {
private:
   EAState m_state;
   CLogger *m_log;
   bool IsAllowed(EAState from,EAState to)
     {
      if(to==STATE_STOP) return true;
      switch(from)
        {
         case STATE_WAIT: return (to==STATE_SCAN);
         case STATE_SCAN: return (to==STATE_ENTRY || to==STATE_WAIT);
         case STATE_ENTRY: return (to==STATE_MANAGE || to==STATE_WAIT);
         case STATE_MANAGE:return (to==STATE_HEDGE || to==STATE_UNWIND || to==STATE_RECOVERY || to==STATE_WAIT);
         case STATE_HEDGE:return (to==STATE_RECOVERY || to==STATE_UNWIND || to==STATE_MANAGE);
         case STATE_RECOVERY:return (to==STATE_MANAGE || to==STATE_UNWIND || to==STATE_WAIT);
         case STATE_UNWIND:return (to==STATE_WAIT || to==STATE_SCAN);
         case STATE_STOP:return false;
        }
      return false;
     }
public:
   void Init(CLogger &log){ m_log=&log; m_state=STATE_WAIT; }
   EAState State(){ return m_state; }
   bool Transition(EAState next,string reason="")
     {
      if(next==m_state) return true;
      if(!IsAllowed(m_state,next))
        {
         m_log.Error("Invalid transition "+IntegerToString(m_state)+"->"+IntegerToString(next)+" "+reason);
         return false;
        }
      m_log.Info("State transition "+IntegerToString(m_state)+"->"+IntegerToString(next)+" "+reason);
      m_state=next;
      return true;
     }
   void EmergencyStop(string why)
     {
      m_log.Error("Emergency STOP: "+why);
      m_state=STATE_STOP;
     }
  };

#endif
