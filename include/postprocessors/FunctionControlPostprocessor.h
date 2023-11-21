//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "GeneralPostprocessor.h"


class FunctionControlPostprocessor : public GeneralPostprocessor
{
public:
  static InputParameters validParams();

  FunctionControlPostprocessor(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;
  using Postprocessor::getValue;
  virtual Real getValue() const override;
protected:

  // the value you want _pps_value to be
  const Real _reff_value;
  // The current post-processor value
  const PostprocessorValue & _pps_value;
  const Real _period;
  Real _period_count;
  Real _next_period_start;
  Real _value;
  Real _previous_dt;
};
