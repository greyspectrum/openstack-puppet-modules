require 'spec_helper'

describe 'nova::logging' do

  let :params do
    {
    }
  end

  let :log_params do
    {
      :logging_context_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s',
      :logging_default_format_string => '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s',
      :logging_debug_format_suffix => '%(funcName)s %(pathname)s:%(lineno)d',
      :logging_exception_prefix => '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s',
      :log_config_append => '/etc/nova/logging.conf',
      :publish_errors => true,
      :default_log_levels => { 
        'amqp' => 'WARN', 'amqplib' => 'WARN', 'boto' => 'WARN',
        'qpid' => 'WARN', 'sqlalchemy' => 'WARN', 'suds' => 'INFO',
        'iso8601' => 'WARN',
        'requests.packages.urllib3.connectionpool' => 'WARN' },
     :fatal_deprecations => true,
     :instance_format => '[instance: %(uuid)s] ',
     :instance_uuid_format => '[instance: %(uuid)s] ',
     :log_date_format => '%Y-%m-%d %H:%M:%S',
    }
  end

  shared_examples_for 'nova-logging' do

    context 'with extended logging options' do
      before { params.merge!( log_params ) }
      it_configures 'logging params set'
    end

    context 'without extended logging options' do
      it_configures 'logging params unset'
    end

  end

  shared_examples_for 'logging params set' do
    it 'enables logging params' do
      should contain_nova_config('DEFAULT/logging_context_format_string').with_value(
        '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [%(request_id)s %(user_identity)s] %(instance)s%(message)s')

      should contain_nova_config('DEFAULT/logging_default_format_string').with_value(
        '%(asctime)s.%(msecs)03d %(process)d %(levelname)s %(name)s [-] %(instance)s%(message)s')

      should contain_nova_config('DEFAULT/logging_debug_format_suffix').with_value(
        '%(funcName)s %(pathname)s:%(lineno)d')

      should contain_nova_config('DEFAULT/logging_exception_prefix').with_value(
       '%(asctime)s.%(msecs)03d %(process)d TRACE %(name)s %(instance)s')

      should contain_nova_config('DEFAULT/log_config_append').with_value(
        '/etc/nova/logging.conf')
      should contain_nova_config('DEFAULT/publish_errors').with_value(
        true)

      should contain_nova_config('DEFAULT/default_log_levels').with_value(
        'amqp=WARN,amqplib=WARN,boto=WARN,iso8601=WARN,qpid=WARN,requests.packages.urllib3.connectionpool=WARN,sqlalchemy=WARN,suds=INFO')

      should contain_nova_config('DEFAULT/fatal_deprecations').with_value(
        true)

      should contain_nova_config('DEFAULT/instance_format').with_value(
        '[instance: %(uuid)s] ')

      should contain_nova_config('DEFAULT/instance_uuid_format').with_value(
        '[instance: %(uuid)s] ')

      should contain_nova_config('DEFAULT/log_date_format').with_value(
        '%Y-%m-%d %H:%M:%S')
    end
  end


  shared_examples_for 'logging params unset' do
   [ :logging_context_format_string, :logging_default_format_string,
     :logging_debug_format_suffix, :logging_exception_prefix,
     :log_config_append, :publish_errors,
     :default_log_levels, :fatal_deprecations,
     :instance_format, :instance_uuid_format,
     :log_date_format, ].each { |param|
        it { should contain_nova_config("DEFAULT/#{param}").with_ensure('absent') }
      }
  end

  context 'on Debian platforms' do
    let :facts do
      { :osfamily => 'Debian' }
    end

    it_configures 'nova-logging'
  end

  context 'on RedHat platforms' do
    let :facts do
      { :osfamily => 'RedHat' }
    end

    it_configures 'nova-logging'
  end

end