class Task < ApplicationRecord
  belongs_to :project, counter_cache: true
  belongs_to :lexicon_group, optional: true
  belongs_to :model, optional: true
  
  TYPES = [
    'Annotate with Lexicon',
    'Train on Annotated Text',
    'Annotate with Model'
  ]

  PRE_TRAINED_MODELS = ['Chemical', 'Disease']
  STATUS = ['requested', 'processing', 'success', 'error', 'canceled']
  def desc

  end
  
  def title 
    TYPES[self.task_type]
  end

  def busy?
    self.status == 'requested' || self.status == 'processing'
  end

  def status_with_icon
    if self.busy?
      "<i class='icon refresh loading'></i> #{self.status.capitalize}".html_safe
    else
      "<i class='icon checkmark'></i> #{self.status.capitalize}".html_safe
    end
  end

  def can_cancel?
    self.status == "requested"
  end

  def type_cls
    if self.task_type == 1
      "train"
    else
      "annotate"
    end
  end
end
