class Leavemailer < ActionMailer::Base
  default :from => "from@example.com"

  def leave_request(leave_application, supervisor)
   
    @type_of_leave = leave_application.type_of_leave
    @reason_for_leave = leave_application.reason_for_leave
    @supervisor = supervisor.email
    mail(
      :from => 'spa@spa.com',
      :subject => 'request for leave approval'
    )
  end

  #  def leave_approval(supervisor)
  #    mail(
  #     :to => supervisor.email
  #    )
  #  end
end
