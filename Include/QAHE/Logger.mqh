#ifndef __QAHE_LOGGER_MQH__
#define __QAHE_LOGGER_MQH__

class CLogger
  {
public:
   void Info(string msg)  { Print("[QAHE][INFO] ",msg); }
   void Warn(string msg)  { Print("[QAHE][WARN] ",msg); }
   void Error(string msg) { Print("[QAHE][ERROR] ",msg); }
  };

#endif
