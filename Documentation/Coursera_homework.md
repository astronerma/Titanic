Coursera homework
========================================================

#### For your selected competition, write a few sentences describing the competition problem as you interpreted it.  You want your writeup to be self-contained so your peer-reviewer does not need to go to Kaggle to study the competition description.  Clarity is more important than detail.  What's the overall goal?  What does the data look like?  How will the answers be evaluated?

I am taking part in Titanic competition on Kaggle. The aim of the competition is to predict survivors of the Titanic catastrophy based on personal information about each passanger. The available data includes a name of the passange, a class in which he/she travelled (1,2,3), sex, age, number of siblings or spouses on board, number of children or parents on board, ticket code, fare, cabin number and port of embarkment (S, Q, C). Kaggle team provides a training set with 891 sample passangers and a test set with 418 passangers. The training set contains information about passanger survival and is used to train a predictive model. The test set does not have information about passangers survival. Once I have my predictive model trained, I will apply it to the test set and submitt my prediction to Kaggle where my predictions will be compared with true survival information kept secret by Kaggle. Kaggle provides a feedback for each submission in the form of an accuracy score defined as a ratio of number of casses predicted correctly to number of all passangers in the test set. In my work I will use classification tree algorithm to build my predictive model.


#### Write a few sentences describing how you approached the problem.  What techniques did you use? 

The data provided is quite clean. In any of my analysis I will not use information about cabin number, and ticket code, as I think this information is not relevant. An age information and port of embarkment for some of the passange was missing. In a first step, I replaced the missing age with a median age for all passangers in training set and a missing port with the most frequent port for all passangers (S).

In my first attempt to build a predictive model I used a decision tree and training data containg age, sex, class and information about children, parents, spouses, and siblings.

#### Write a few sentences describing how you implemented your approach.  What languages and libraries did you use? What challenges did you run into?

In my analysis I used R language and a Rstudio client. For the decission tree I used a function "tree"" from a library called "tree". I used the function with only default parameters. To estimate the model performance on a test set, I performed a cross validation using 10-fold cross valdation and a leave one out cross validation. I wrote my own scripts in R to do this. I used function "predict" to apply my tree to the test data and and produce "survival" column for the submission. 


#### Write a few sentences assessing your approach.  Did it work?  What do you think the problems were?

My first model gave me 0.805 accuracy (as defined in first question) on a training set, that means that it is able to predict ~80% of cases in training set correctly. The cross validation results were similar, 10-fold cross validation gave accuracy of 0.792 and leave one out cross validation 0.718. The model submission to Kaggle resulted in an accuracy on a test set of 0.755. This is not so good. This placed me at 3202 place in leaderboard. This is well below a benchmark model (2223 place) in which a classification is based purely on gender, marking all women as survving and all men as not surviving. To improve my model, I will now try to improve an age estimation instead of using a simple median value.


#### Write a few sentences describing how you improved on your solution, and whether or not it worked.

I noticed in my modeling that age is an important variable in deciding who survives and who doesn't. To improve my results I decided to calculate missing ages more precisely. First thing I did, I used name variable to extract a title of the passanger (Mr, Miss, etc). Based on combined training and test sets, I calculated an median age for each title. Unsurprisingly, there are some large differences between median ages for each title. I also noticed that "Mr" is the most frequenct title and the spread of age values within the "Mr" title is very large. I noticed that an average age for "Mr"
is different for different classes they traveled in. In my next step I used a regression method to estimate a missing age based on passangers title and class in which they travelled. For the regression I used lm function in R. After all missing ages have been filled, I used a decision tree to build a predictive model and submitted it to Kaggle. This time the accuracy was 0.79426 which put me on 159 place in leaderboard. 














