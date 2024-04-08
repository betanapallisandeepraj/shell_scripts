#!/bin/bash

compute_pwm() {
  pwm=63
  pwr=0
  pwr2=1.0
  /scripts_lima_phy/freq_11n.sh 1635
  dl-prism-ctrl 1 5 1635
  dl-prism-ctrl 1 0 3
  /scripts_lima_phy/start.sh
  sleep 0.5

  while ("$pwr < 19.75" || "$pwr > 20.25"); do
    dl-prism-ctrl 1 14 $pwm
    sleep 0.5
    pwr=$(python PM.py 1635)
    # add correction factor
    pwr=$pwr+31.2
    #retest for miss capture power
    if ("$pwr < 0" && "$pwr2 > 0"); then
      /scripts_lima_phy/stop.sh
      /scripts_lima_phy/start.sh
      sleep 0.5
      pwr=$(python PM.py 1635)
      # add correction factor
      pwr=$pwr+31.2
      pwr2=$pwr
    fi
    if ("$pwr < 20"); then
      deltaPower=20-$pwr
      if ("$deltaPower > 0.25"); then
        deltapwm=$deltaPower/0.25
        pwm=$pwm-$deltapwm
      fi
    fi
    if ("$pwr > 20"); then
      deltaPower=$pwr-20
      if ("$deltaPower > 0.25"); then
        deltapwm=$deltaPower/0.25
        pwm=$pwm+$deltapwm
      fi
    fi
    if ($pwm <0) || ($pwm >127); then
      echo Error1
      /scripts_lima_phy/stop.sh
      return 1
    fi
    if ($pwr2 <0); then
      echo Error2
      /scripts_lima_phy/stop.sh
      return 1
    fi
  done
  /scripts_lima_phy/stop.sh
}
