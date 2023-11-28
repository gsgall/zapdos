//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "PeriodicTimeIntegratedPostprocessor.h"

registerMooseObject("ZapdosApp", PeriodicTimeIntegratedPostprocessor);

InputParameters
PeriodicTimeIntegratedPostprocessor::validParams()
{
  InputParameters params = TimeIntegratedPostprocessor::validParams();
  params.addClassDescription("Integrate a Postprocessor value over a period in time using trapezoidal rule.");
  params.addParam<Real>("cycle_frequency", "The frequency of the process. Used to calculate the period over which you are integrating.");
  return params;
}

PeriodicTimeIntegratedPostprocessor::PeriodicTimeIntegratedPostprocessor(const InputParameters & parameters)
  : TimeIntegratedPostprocessor(parameters),
    _period(1.0 / getParam<Real>("cycle_frequency")),
    _period_count(0),
    _next_period_start(_period)
{
}


void
PeriodicTimeIntegratedPostprocessor::execute()
{
  // offset by 1 timestep so that we get the full value at the
  // actual period end
  TimeIntegratedPostprocessor::execute();
  if (_t >= _next_period_start)
  {
    _period_count += 1;
    _next_period_start = (_period_count + 1) * _period;
    this->_value = 0;
    return;
  }
}
