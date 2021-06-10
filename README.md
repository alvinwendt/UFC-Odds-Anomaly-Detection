# UFC Odds Anomaly Detection (Capstone)

<p align="center">
  <a href="" rel="noopener">
 <img src="https://user-images.githubusercontent.com/70002987/119577744-d6ac1f00-bd80-11eb-9934-e73f0a449fa2.jpg" alt="Project logo"></a>
</p>
<h1 align="center">UFC Odds Anomaly Detection (Capstone)</h1>


</div>


<h2 align="center"> This project is a final capstone for Nashville Software School (NSS) to understand UFC fight factors that could create a predictive model and detect sportbook odds anomalies related to a fight's expected outcome.
    <br> 
</p>

## 📝 Table of Contents
- [Problem Statement](#problem_statement)
- [Idea / Solution](#idea)
- [Dependencies / Limitations](#limitations)
- [Data](#data)
- [Features](#features)
- [Model](#model)
- [Future Scope](#future_scope)
- [Tools Used for Project](#built)
- [Authors](#authors)
- [Acknowledgments](#acknowledgments)

## 🧐 Problem Statement <a name = "problem_statement"></a>
Is it possible to understand to create a model to predict expected outcomes of UFC fights and be able to compare those outcomes to sports bet odds in order to detect anomalies?


## 💡 Idea / Solution <a name = "idea"></a>
- Create a UFC Fight Predictive Model
- Compare probabilities of expected outcomes to implied probability from odds data to detect anomalies


## ⛓️ Dependencies / Limitations <a name = "limitations"></a>
- The quality and quantity of existing UFC and sports betting data
- Determinability of the expected outcome of fights due to high volatility
- Some features that may be impactful to the model are unmeasurable (i.e. Heart, Popularity, Unknown Injuries)

## 🏁 Data Collection with Web Scraping <a name = "data"></a>
Scraped Data from various sources, including [UFCstats.com](https://www.ufcstats.com/), [Sherdog.com](https://www.sherdog.com/) and [BestFightOdds.com](https://www.bestfightodds.com/)

## 🎈 Features <a name="features"></a>
|Label        | Description |
| ------------- |-------------| 
|R_| Red Corner|
|B_| Blue Corner|
|R_fighter, B_fighter| Fighter names|
|R_odds, B_odds| The American odds that the fighter will win. Scraped from bestfightodds.com|
|Spread| Range between underdog and favorite odds|
|R_ev, B_ev| The profit on a 100 credit winning bet|
|date| The date of the fight|
|location| The location of the fight|
|country| The country the fight occurs in|
|Winner| The winner of the fight [Red or Blue]|
|title_bout| Was this a title bout?|
|weight_class| The weight class of the bout|
|gender| Gender of the combatants|
|no_of_rounds| The number of rounds in the fight|
|B_win_by_TKO_Doctor_Stoppage, R_win_by_TKO_Doctor_Stoppage| Wins by Doctor Stoppage|
<br>
<details><summary>Click to expand and see more features...</summary>

|  |  |
| ------------- |-------------| 
|no_of_rounds| The number of rounds in the fight|
|B_current_lose_streak, R_current_lose_streak| Current losing streak|
|B_current_win_streak, R_current_win_streak| Current winning streak|
|B_draw, R_draw| Number of draws|
|B_avg_SIG_STR_landed, R_avg_SIG_STR_landed | Significant Strikes Landed per minute|
|B_avg_SIG_STR_pct, R_avg_SIG_STR_pct| Significant Striking Accuracy|
|B_avg_SUB_ATT, R_avg_SUB_ATT| Average Submissions Attempted per 15 Minutes|
|B_avg_TD_landed, R_avg_TD_landed| Average takedowns landed per 15 minutes|
|B_avg_TD_pct, R_avg_TD_pct| Takedown accuracy|
|B_longest_win_streak, R_longest_win_streak| Longest winning streak|
|B_losses, R_losses| Total number of losses|
|B_total_rounds_fought, R_total_rounds_fought| Total rounds fought|
|B_total_title_bouts, R_total_title_bouts| Total number of title bouts|
|B_win_by_Decision_Majority, R_win_by_Decision_Majority| Wins by Majority Decision|
|B_win_by_Decision_Split, R_win_by_Decision_Split| Wins by Split Decision|
|B_win_by_Decision_Unanimous, R_win_by_Decision_Unanimous| Wins by Unanimous Decision|
|B_win_by_KO/TKO, R_win_by_KO/TKO| Wins by KO/TKO|
|B_win_by_Submission, R_win_by_Submission| Wins by Submission|
|B_win_by_TKO_Doctor_Stoppage, R_win_by_TKO_Doctor_Stoppage| Wins by Doctor Stoppage|
|B_wins, R_wins| Total career wins|
|B_Stance, R_stance| Fighter stance|
|B_Height_cms, R_Height_cms| Fighter height in cms|
|B_Reach_cms, R_Reach_cms| Fighter reach in cms|
|B_Weight_lbs, R_Weight_lbs| Fighter weight in pounds|
|lose_streak_dif| R_Fighter Lose Streak Minus B_Fighter Lose Streak|
|win_streak_dif | R_Fighter Win Streak Minus B_Fighter Win Streak|
|win_dif|R_Fighter Wins Minus B_Fighter Wins|
|loss_dif|R_Fighter Losses Minus B_Fighter Losses|
|total_round_dif|R_Fighter Total Rounds Minus B_Fighter Total Rounds|
|total_title_bout_dif|R_Fighter Total Title Bouts Minus B_Fighter Total Title Bouts|
|ko_dif|R_Fighter Total KOs Minus B_Fighter Total Kos|
|sub_dif|R_Fighter Total submissions Minus B_Fighter Total submissions |
|height_dif|R_Fighter Height Minus B_Fighter Height|
|reach_dif|R_Fighter Reach Minus B_Fighter Reach|
|age_dif|R_Fighter Age Minus B_Fighter Age|
|sig_str_dif|R_Fighter Average Significant Strikes Minus B_Fighter Average Significant Strikes|
|avg_sub_att_dif|R_Fighter Average Submissions Attempted Minus B_Fighter Average Submissions Attempted|
|avg_td_dif|R_Fighter Average Takedowns Minus B_Fighter Average Takedowns|
|empty_arena|Was the fight held in a empty no crowd arena?|
</details>

## 💻 Model <a name = "model"></a>
### The following were the models utilized to create a predictive model:
***H2o Library***
1. Generalized Linear Regression (GLM)
2. Random Forest with Hypertuning
3. Gradiant Boosting Model (GBM)
4. Deep Learning

***Tidyverse Library***
1. Random Forest with Hypertuning
2. XGBoost with Hypertuning

### ***Below are the scoreing metrics from the models produced***

|Model        |Library Used| Accuracy |Recall| Precision | F1-Score |
| ---------- |-----------| --|-------------| ------ |-----------|
|GLM       |H2o| 0.61 |0.65| 0.75 | 0.70 |
|GBM       | H2o|0.61 |0.64| 0.77 | 0.70 |
|Random Forest  |H2o| 0.61 |0.63| 0.85 | 0.72 |
|Deep Learning |H2o| 0.55 |0.62| 0.65 | 0.63 |
|Random Forest (Hypertuned) |Tidymodels| 0.57 |0.91| 0.56 | 0.79 |
|XGBoost (Hypertuned) |Tidymodels| 0.57 |0.81| 0.56 | 0.67 |

A last approach was to perform a stacked ensemble method by combining models. This is a proven method to boost model performance.
After stacking was performed, the new model returned the folloing metrics.

|Model        |Library Used| Accuracy |Recall| Precision | F1-Score |
| ---------- |-----------| --|-------------| ------ |-----------|
|Stacked Ensemble   |H2o| 0.63 |0.66| 0.77 | 0.72 |

## 🚀 Future Scope <a name = "future_scope"></a>
1. Besides betting on fight outcomes, there are other types of bet such as when a round will end or how the fight will end such as a decision or knockout. I would be curious to see if a better model could be created with a difference in target variable. 

2. I would love to have created a live model that predicts based on adjusting odds during a fight as odd shift as the fight unfolds. 

3. Additionally, more time dedicated to the predictive model for expected outcomes with an R Shiny App implementation would have been fun and valuable.

## ⛏️ Tools Used <a name = "built"></a>
- Primary Coding Language - [R](https://www.r-project.org/)
- Libraries: [Tidyverse](https://www.tidyverse.org), [H2o](www.h2o.ai/), [Tidy Models](https://www.tidymodels.org/), [VIP](https://cran.r-project.org/web/packages/vip/vip.pdf), [Data Explorer](https://cran.r-project.org/web/packages/DataExplorer/vignettes/dataexplorer-intro.html)

## ✍️ Author <a name = "authors"></a>
- [Alvin Wendt](https://alvinwendt.github.io/Alvin-Wendt-Portfolio/) - Idea & Work

## 🎉 Acknowledgments <a name = "acknowledgments"></a>
  Hat tip to the following people for their support during this capstone project:
- Michael Holloway
- Tim Dobbins
- Suneethi Ford
