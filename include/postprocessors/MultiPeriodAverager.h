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

class MultiPeriodAverager : public GeneralPostprocessor
{
public:
  static InputParameters validParams();

  MultiPeriodAverager(const InputParameters & parameters);

  virtual void initialize() override;
  virtual void execute() override;
  using Postprocessor::getValue;
  virtual Real getValue() const override;

protected:
  // The current post-processor value
  Real _value;
  Real _temp_value;
  Real _period_count;
  Real _next_period_start;
  Real _cyclic_period_count;
  const Real _period;
  Real _num_periods;

  const PostprocessorValue & _pps_value_old;
};
