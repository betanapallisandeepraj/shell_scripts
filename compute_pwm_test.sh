#!/bin/bash
powerAccuracy=0.25
calPower=20
# currentPathLoss=31.2
currentPathLoss=$2
maxPWM=0
minPWM=127
echo "arg1=$1"
compute_pwm() {
  max=0
  min=127
  pwm=$((($max + $min) / 2))
  # pwm=27
  ll=$(echo $calPower-$powerAccuracy | bc)
  hl=$(echo $calPower+$powerAccuracy | bc)
  var=$5
  echo "var=$var"
  pwr=0
  pwr2=1.0
  echo "ll=$ll,pwr=$pwr,hl=$hl"
  while (($(echo "$pwr < $ll" | bc -l))) || (($(echo "$pwr > $hl" | bc -l))); do
    # echo $1
    # echo $4
    # echo $3
    echo "${LINENO}:pwm=$pwm"

    ANT=$(($1 << 31))
    INDEX=$(($4 << 26))
    FREQ=$(($3 << 12))
    PWM=$pwm

    value=$(($ANT + $INDEX + $FREQ + $PWM))
    #pwr=$(python PM.py $3)
    # pwr=$(echo "-15.2" | bc)
    pwr=$(echo $var | bc)
    echo "${LINENO}:pwr=$pwr"
    # add correction factor
    pwr=$(echo $pwr+$currentPathLoss | bc)
    echo "${LINENO}:pwr=$pwr"
    # #retest for miss capture power
    # if (($(echo "$pwr < 0" | bc -l))) && (($(echo "$pwr2 > 0" | bc -l))); then
    #   #pwr=$(python PM.py $3)
    #   pwr=$(echo "-10.1" | bc)
    #   echo "${LINENO}:pwr=$pwr"
    #   # add correction factor
    #   pwr=$(echo $pwr+$currentPathLoss | bc)
    #   echo "${LINENO}:pwr=$pwr"
    #   pwr2=$pwr
    # fi

    if (($(echo "$pwr < $calPower" | bc -l))); then
      echo "${LINENO}:deltaPower=$deltaPower"
      deltaPower=$(echo $calPower-$pwr | bc)
      echo "${LINENO}:deltaPower=$deltaPower"
      if (($(echo "$deltaPower > $powerAccuracy" | bc -l))); then
        echo "${LINENO}:deltapwm=$deltapwm"
        deltapwm=$(echo $deltaPower/0.25 | bc)
        echo "${LINENO}:deltapwm=$deltapwm"
        pwm=$(echo $pwm-$deltapwm | bc)
        echo "${LINENO}:pwm=$pwm"
      fi
    fi
    if (($(echo "$pwr > $calPower" | bc -l))); then
      deltaPower=$(echo $pwr-$calPower | bc)
      if (($(echo "$deltaPower > $powerAccuracy" | bc -l))); then
        echo "${LINENO}:deltapwm=$deltapwm"
        deltapwm=$(echo $deltaPower/0.25 | bc)
        echo "${LINENO}:deltapwm=$deltapwm"
        pwm=$(echo $pwm+$deltapwm | bc)
        echo "${LINENO}:pwm=$pwm"
      fi
    fi
    echo "${LINENO}:pwm=$pwm,$(($maxPWM + 0)),$(($minPWM - 0))"
    if (($(echo "$pwm < $(($maxPWM + 0))" | bc -l))) || (($(echo "$pwm > $(($minPWM - 0))" | bc -l))); then
      echo Error1
      return 1
    fi
    if (($(echo "$pwr2 < 0" | bc -l))); then
      echo Error2
      return 1
    fi
    echo "${LINENO}:ll=$ll,pwr=$pwr,hl=$hl"
  done

  echo "${LINENO}:pwm=$pwm"
}
compute_pwm 0 0 2245 10 $1
