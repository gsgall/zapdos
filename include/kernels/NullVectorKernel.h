#pragma once

#include "ADKernel.h"

/**
 *
 */
class NullVectorKernel : public ADKernel
{
public:
  static InputParameters validParams();

  NullVectorKernel(const InputParameters & parameters);

protected:
  const ADVectorVariableValue & _velocity;
  virtual ADReal computeQpResidual() override;
};
