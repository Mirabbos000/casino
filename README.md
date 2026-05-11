# QAHE (Quant Adaptive Hedge Engine) - MQL5 Framework

Production-oriented modular EA framework for XAUUSD with a survival-first mandate.

## Structure
- `Experts/QAHE.mq5`: EA orchestration and state-driven runtime.
- `Include/QAHE/*.mqh`: modular engines for volatility, entropy, probability, risk, hedge, survival, execution, and Monte Carlo stress tests.

## Design Principles
- Non-martingale, no infinite grids, no fixed-lot averaging.
- Probabilistic entry scoring, adaptive volatility/entropy filtering.
- Strict drawdown/exposure protection and panic stop semantics.

## Monte Carlo Usage
Use `CMonteCarloEngine` with return arrays from strategy tester logs to evaluate:
- max/avg DD
- ruin probability
- worst equity path
- configuration safety gate (`safe`)
