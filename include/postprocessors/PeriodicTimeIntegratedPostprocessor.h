//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#pragma once

#include "TimeIntegratedPostprocessor.h"

/**
 * Integrate a post-processor value over time using trapezoidal rule
 */
class PeriodicTimeIntegratedPostprocessor : public TimeIntegratedPostprocessor
{
public:
  static InputParameters validParams();

  PeriodicTimeIntegratedPostprocessor(const InputParameters & parameters);

  // virtual void initialize() override;
  virtual void execute() override;
  // using Postprocessor::getValue;
  // virtual Real getValue() const override;

protected:
  const Real _period;
  Real _period_count;
  Real _next_period_start;

};
