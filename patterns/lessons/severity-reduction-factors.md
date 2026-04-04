\# Severity Reduction Factors



Lessons learned dari bug bounty submissions yang di-downgrade atau rejected.



\## 1. Manual Operator Review



Kalau ada human gate sebelum execution (admin approval, operator review, multisig), severity langsung turun.



\*\*Pattern:\*\* Delayed execution → manual review → execute

\*\*Impact:\*\* Bug valid tapi "operationally mitigated"



\## 2. Threshold-Gated Paths



Bug cuma trigger di edge case (high amount, specific conditions). Attack surface kecil = limited scope = lower severity.



\*\*Check:\*\* Path ini kena threshold berapa? Siapa yang realistically hit threshold ini?



\## 3. Economic Viability



"Uneconomic to exploit" = instant Low/Informative. Cost of attack harus < potential gain.



\*\*Check:\*\* Berapa gas/fee untuk execute attack vs potential profit?



\## 4. Fee/Cost vs Direct Loss



Protocol fee externalization atau cost shift ≠ direct fund loss. Programs prioritize user fund loss over protocol operational cost.



\*\*Hierarchy:\*\* User fund loss > Protocol fund loss > Fee/cost issues > Operational inefficiency



\## 5. Report Family / Known Issues



Kalau issue udah pernah reported dalam kategori yang sama, bisa dianggap:

\- Duplicate

\- Known limitation (accepted risk)

\- Already mitigated



\*\*Pre-submit:\*\* Search disclosed reports, check program updates/changelog



\---



\## Pre-Submit Checklist



Before submitting, verify:



\- \[ ] No manual/admin gate in execution path?

\- \[ ] Bug triggers in normal flow, not just edge case?

\- \[ ] Attack is economically viable?

\- \[ ] Impact is direct fund loss, not just fee/cost?

\- \[ ] Issue not already disclosed/known?



Source: Dexalot DEXASCN-236 (Informative, April 2026)

