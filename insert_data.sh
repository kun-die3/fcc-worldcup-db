#! /bin/bash
E
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do

if [[ $WINNER != 'winner' ]]
then
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  echo $WINNER_ID

  if [[ -z $WINNER_ID ]]
  then
    INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    echo $INSERT_WINNER_TEAM
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  echo $OPPONENT_ID

  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    echo $INSERT_OPPONENT_TEAM
  fi

OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

fi

if [[ -z $WINNER_ID ]] || [[ -z $OPPONENT_ID ]]
then
  WINNER_ID=null
  OPPONENT_ID=null
fi

INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")
echo $INSERT_GAME_DATA


done