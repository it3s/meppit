# require 'ostruct'

class PagesController < ApplicationController
  def frontpage
    @news = news
  end

  private

  def news
    # MOCKED
    [
      OpenStruct.new({
        title: 'Por favor, onde é o Serviço de Acesso à Informação?',
        link: 'blog.mootiro.org/?p=223',
        date: Date.new(2012, 12, 11),
      }),
      OpenStruct.new({
        title: 'Adolescentes manuseiam software de produção colaborativa',
        link: 'blog.mootiro.org/?p=192',
        date: Date.new(2012, 11, 27),
      }),
      OpenStruct.new({
        title: 'As novas tecnologias e a revolução cidadã',
        link: 'blog.mootiro.org/?p=174',
        date: Date.new(2012, 11, 21),
      }),
      OpenStruct.new({
        title: 'Formação aborda qualificação de dados públicos',
        link: 'blog.mootiro.org/?p=179',
        date: Date.new(2012, 11, 21),
      }),
    ]
  end
end
