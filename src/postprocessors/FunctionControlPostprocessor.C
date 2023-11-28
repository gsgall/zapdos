//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "FunctionControlPostprocessor.h"

registerMooseObject("ZapdosApp", FunctionControlPostprocessor);

InputParameters
FunctionControlPostprocessor::validParams()
{
  InputParameters params = GeneralPostprocessor::validParams();
  params.addClassDescription("Multiply a post processor by a number");
  params.addParam<Real>("initial_value", "The initial value for this postprocessor");
  params.addParam<Real>("reference_value", "The power deposition you want the plasma to have");
  params.addParam<PostprocessorName>("value", "The name of the postprocessor which calculates the power");
  params.addParam<Real>("start_cycle", 1, "The number of cycle on which you want the postprocessor value to begin being modified");
  params.addParam<Real>("cycles_between_modification", 0, "The number of cycles between the modifications of the post processor value");
  params.addParam<Real>("cycle_frequency", "The frequency of the process. Used to calculate the period over which you are integrating.");
  return params;
}

FunctionControlPostprocessor::FunctionControlPostprocessor(const InputParameters & parameters)
  : GeneralPostprocessor(parameters),
  _reff_value(getParam<Real>("reference_value")),
  _start_cycle(getParam<Real>("start_cycle")),
  _cycles_between(getParam<Real>("cycles_between_modification")),
  _pps_value_old(getPostprocessorValueOld("value")),
  _period(1.0 / getParam<Real>("cycle_frequency")),
  _period_count(0),
  _value(getParam<Real>("initial_value"))
{
  _next_period_start = _period;
  _next_modification_start = _start_cycle * _period;
}


void
FunctionControlPostprocessor::initialize()
{
}

void
FunctionControlPostprocessor::execute()
{
  if (_t >= _next_period_start)
  {
    _period_count += 1;
    _next_period_start = (_period_count + 1) * _period;
  }

  if (_t >= _next_modification_start)
  {
    std::cout << "Updating value" << std::endl;
    _next_modification_start = (_period_count + _cycles_between + 1) * _period;
    this->_value = this->_value * _reff_value / _pps_value_old;
  }
}

Real
FunctionControlPostprocessor::getValue() const
{
  return this->_value;
}
