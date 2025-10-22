class MaterialPolicy < ApplicationPolicy
  # 'user' é o 'current_user' (logado)
  # 'record' é o objeto que estamos tentando acessar (o @material)

  # Quem pode ver os materiais?
  def show?
    true 
  end

  # Qualquer usuário logado pode criar materiais.
  def create?
    user.present? 
  end

  # Quem pode atualizar?
  def update?
    user.present? && user == record.user
  end

  # Quem pode deletar?
  def destroy?
    update? 
  end
end